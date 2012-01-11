# From http://railscasts.com/episodes/86-logging-variables
# Call me like this:
# logger.debug_variables(binding)

logger = ActiveRecord::Base.logger
def logger.debug_variables(bind)
  vars = eval('local_variables + instance_variables', bind)
  vars.each do |var|
    debug  "#{var} = #{eval(var, bind).inspect}"
  end
end