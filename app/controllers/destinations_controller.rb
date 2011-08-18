class DestinationsController < ApplicationController
  before_filter :load_group
  
  # GET /destinations
  # GET /destinations.xml
  def index
    @destinations = Destination.all
    @groups = current_user.groups
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @destinations }
    end
  end

  # GET /destinations/1
  # GET /destinations/1.xml
  def show
    @destination = Destination.find(params[:id])
    @groups = current_user.groups

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @destination }
    end
  end

  # GET /destinations/new
  # GET /destinations/new.xml
  def new
    @destination = Destination.new
    @groups = current_user.groups
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @destination }
    end
  end

  # GET /destinations/1/edit
  def edit
    @destination = Destination.find(params[:id])
    @groups = current_user.groups
  end

  # POST /destinations
  # POST /destinations.xml
  def create
    @destination = Destination.new(params[:destination])
    @destination.group = @group
    @groups = current_user.groups

    respond_to do |format|
      if @destination.save
        format.html { redirect_to(group_url(@group), :notice => 'Check in was successfully created.') }
        format.xml  { render :xml => @destination, :status => :created, :location => @destination }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @destination.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /destinations/1
  # PUT /destinations/1.xml
  def update
    @destination = Destination.find(params[:id])
    @groups = current_user.groups

    respond_to do |format|
      if @destination.update_attributes(params[:destination])
        format.html { redirect_to(@group, :notice => 'Check in was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @destination.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /destinations/1
  # DELETE /destinations/1.xml
  def destroy
    @destination = Destination.find(params[:id])
    @destination.destroy
    @groups = current_user.groups

    respond_to do |format|
      format.html { redirect_to(destinations_url) }
      format.xml  { head :ok }
    end
  end

  private
  def load_group
    if params[:group_id]
      @group = Group.find(params[:group_id])
    elsif params[:destination][:group_id]
      @group = Group.find(params[:destination][:group_id])
    end
  end
end
