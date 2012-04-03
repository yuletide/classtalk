class GroupsController < ApplicationController
  before_filter :authenticate_user!, :except=>[:receive_message, :receive_email]
  before_filter :load_groups, :except =>[:receive_message, :receive_email]

  def index
    if @groups.blank?
  	else
      @page_title = "Your Groups"
      @groups = current_user.groups
      @group = @groups.first #TODO: remember what the user viewed the last time they were on the page
      @messages = @group.logged_messages.unique_messages.order("created_at DESC").all
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @groups }
    end
  end

  def show
    @group = current_user.groups.find(params[:id])
    @messages = @group.logged_messages.unique_messages.order("created_at DESC").all
    @page_title = @group.title

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @group }
    end
  end

  def members
    @group = current_user.groups.find(params[:id])
    @page_title = @group.title
    @members = @group.students

    respond_to do |format|
      format.html # members.html.erb
      format.xml  { render :xml => @members }
    end
  end


  def new
    @group = current_user.groups.new
    @page_title = "New Group"
    @students=[Student.new]*10

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @group }
    end
  end

  def edit
    @group = current_user.groups.find(params[:id])
    @page_title = "#{@group.title}"
    @students = @group.students
  end

  def create
    params[:group][:user_id]=current_user.id
    @group = current_user.groups.new(params[:group])
    @group.phone_number = get_new_phone_number
    @group.destination_phone_number = get_new_phone_number
    @page_title = "New Groups"

    respond_to do |format|
      if @group.save
        format.html { redirect_to(group_path(@group), :notice => 'Group was successfully created.') }
        format.xml  { render :xml => @group, :status => :created, :location => @group }
      else
        #TODO: find a better, less API-intensive way to ensure we don't abuse our tropo provisioning
        if @group.phone_number.nil? || @group.destination_phone_number.nil?
          @group.errors[:phone_number] = ["Could not provision phone number at this time. Please try again later."]
        else
          destroy_phone_number(@group.phone_number)
          destroy_phone_number(@group.destination_phone_number)
          @group.phone_number=nil
          @group.estination_dphone_number=nil
        end
        format.html { render :action => "new" }
        format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
      end
    end

  end

  def update
    @group = current_user.groups.find(params[:id])
    @page_title = "#{@group.title}"

    respond_to do |format|
      if @group.update_attributes(params[:group])
        @group.reload if @group.students.any?(&:marked_for_destruction?)
        format.html { redirect_to(@group) }
        format.js
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @group = current_user.groups.find(params[:id])
    destroy_phone_number(@group.phone_number)
    destroy_phone_number(@group.destination_phone_number)
    @group.destroy

    respond_to do |format|
      format.html { redirect_to(groups_url) }
      format.xml  { head :ok }
    end
  end

  require 'csv'
  def bulk_upload_students
    @group = current_user.groups.find(params[:id])

    if !@group
      #404 or something?
      #return
    end

    csv = CSV.parse(params[:upload][:csv].read)

    #in future: these might be programatically defined, and possibly merge multiple cells.
    retrieve_procs = {
      :name => lambda {|row| row[0]},
      :phone_number => lambda {|row| row[1]},
      :email => lambda {|row| row[2]}
    }

    new_students=0
    updated_students=0

    csv.each do |row|
        #hash.merge(self) accomplishes a .map, but keeps us a hash, not an array.
      given = retrieve_procs.merge(retrieve_procs) {|key,value_proc| value_proc[row]}
      #TODO: we should check if this is ambiguous, instead of giving priority to the first.
      @student = @group.students.where("name = ? OR phone_number = ? OR email = ?",*given.values_at(:name,:phone_number,:email)).first

      if @student
        @student.update_attributes(given) #todo: check for errors
        updated_students+=1
      else
        @student = @group.students.create(given) #todo: check for errors
        new_students+=1
      end

    end
    redirect_to @group, :notice=> "upload good" #helper.pluralize(new_students,"student") +" created and " + helper.pluralize(updated_students,"student") + "updated"
  end

  #POST groups/:id/send_message, sends a message to all members of group
  def send_message
    @group = current_user.groups.find(params[:id])
    message = @group.user.display_name+": "+params[:message][:content] #TODO: safety, parsing, whatever.
    #TODO: ensure group found

    if params[:commit].match /later/i
      scheduled_run = Time.zone.local(*params[:date].values_at(*%w{year month day hour}).map(&:to_i))

      #schedule 5 minutes early so we don't accidentally hit anything silly on cron job execution time
      @group.delay(:run_at=>scheduled_run-5.minutes).send_message(message,@group.user)
      pretty_time = scheduled_run.strftime("%A, %B %d, %I:%M %p %Z")
      redirect_to @group, :notice=>"Message successfully scheduled for #{pretty_time}" #if actually successful, or something
    else
      @group.send_message(message,@group.user)
      redirect_to @group, :notice=>"Message sent successfully" #if actually successful, or something
    end

  end

  #POST groups/receive_message, receives a message as a JSON post, and figures out what to do with it.
  def receive_message
    _from = params[:session][:from][:id]
    _to = params[:session][:to][:id]
    _to = $1 if _to=~/^1(\d{10})$/
    _from = $1 if _from=~/^1(\d{10})$/

    if (@group=Group.find_by_phone_number(_to))
      puts 'found user in group'
      sent_by_admin=@group.user.phone_number==_from
      @sending_student = @group.students.find_by_phone_number(_from)
      @sending_person = sent_by_admin ? @group.user : @sending_student

      handle_group_message(@group,@sending_person,params[:message])
    elsif (@group=Group.find_by_destination_phone_number(_to))
      sent_by_admin=@group.user.phone_number==_from
      @sending_student = @group.students.find_by_phone_number(_from)
      @sending_person = sent_by_admin ? @group.user : @sending_student

      handle_destination_message(@group,@sending_person,params[:message])
    end

    render :text=>"sent", :status=>202
    #needs to return something API-like, yo
  end

  #receive a POSTed email as a form from cloudmailin. figure out what to do with it.
  def receive_email

    from = params[:from]
      body =  params[:plain].gsub(/^On .* wrote:\r?$\s*(^>.*$\s*)+/,'') #strip out replies and whatnot

    #if one of the to addresses matches us, use that one. todo - correctly handle mulitple emails, or correctly fail
    if params[:to].match(/group\+(\d+)@/) && @group = Group.find($1)
      @sender = @group.user.email==from ? @group.user : @group.students.find_by_email(from)
      handle_group_message(@group,@sender,body)
    elsif params[:to].match(/group_destinations\+(\d+)@/) && @group = Group.find($1)
      @sender = @group.user.email==from ? @group.user : @group.students.find_by_email(from)
      handle_destination_message(@group,@sender,body)
    end


    render :text => 'success', :status => 200
  end

  def load_groups
    @groups = current_user.groups.all
  end

  private
  def get_new_phone_number
    r=$outbound_flocky.create_phone_number_synchronous(nil)
    if r[:response].code == 200
      return r[:response].parsed_response["href"].match(/\+1(\d{10})/)[1] rescue nil
    end

    return nil
  end
  def destroy_phone_number(num)
    $outbound_flocky.destroy_phone_number_synchronous(num)
  end

  def handle_group_message(group,sender,message)
    return unless [group,sender,message].all?(&:present?)

    sent_by_admin = (sender == group.user)

    case message
      when /^\s*#remove[\s_]*me/
        unless sent_by_admin
          @group.send_message("You will no longer receive messages from #{@group.title}. Sorry to see you go!",nil,[@sending_student])
          @sending_student.update_attribute(:phone_number,nil)
        end
      when /^\s*#(\w+)\s*$/
        unless sent_by_admin
          hashtag = $1
          @destination = @group.destinations.find_by_hashtag(hashtag)

          if @destination
            @destination.checkin(sender)
          else
            @group.send_message("sorry, '#{hashtag}' doesn't seem to be a valid destination", nil, [sender])
          end

        end
      else
        message = (sent_by_admin ? group.user.display_name : sender.name)+": "+message

        send_to = if sent_by_admin
          group.students
        elsif group.replies_all?
          [group.user] + group.students - [sender]
        else
          [group.user]
        end

        group.send_message(message,sender, send_to)
      end
  end

  def handle_destination_message(group,sender,message)
    return if (sender == group.user)

    #we have a student, make sure they're checked in to _a_ group
    if sender.active_checkin.blank?
      group.send_message("you're not currently checked in to any group. send in the hashtag of a destination to check in",nil,[sender])
    else
      @checkin = sender.active_checkin
      @question = @checkin.current_question
      sender.answers << Answer.new(:question=>@question, :content=>message)

      @checkin.current_question_index += 1
      @checkin.save
      @checkin.destination.send_current_question(sender)
    end

  end
end
