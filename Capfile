load 'deploy' if respond_to?(:namespace) # cap2 differentiator
Dir['vendor/gems/*/recipes/*.rb','vendor/plugins/*/recipes/*.rb'].each { |plugin| load(plugin) }

load 'config/deploy' # remove this line to skip loading any of the default tasks

def disable_rvm_shell(&block)

  old_shell = self[:default_shell]

  self[:default_shell] = nil

  yield

  self[:default_shell] = old_shell

end


