module Classtalk
  module Spec
    module Matchers

      RSpec::Matchers.define :have_errors_on do |field|
        chain :with_message do |message|
          @message = message
        end

        match do |model|
          model.valid?
          @has_error = has_error?(model, field)

          if @message
            @has_error && model.errors[field].include?(@message)
          else
            @has_error
          end
        end

        failure_message_for_should do |model|
          msg = "#{model} should #{description}"

          if @has_error && @message
            msg << " while it is #{model.errors[field].inspect}"
          end

          msg
        end

        failure_message_for_should_not do |model|
          "#{model.class} should not have an error on field #{field.inspect}"
        end

        description do |model|
          msg = "have an error on field #{field.inspect}"
          msg << " with a message #{@message.inspect}" if @message
          msg
        end

        def has_error?(model, field)
          !model.errors[field].blank?
        end
      end

    end
  end
end
