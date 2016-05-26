require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new
agent = Agent.new

agent.register_to_monitor unless agent.registered?

scheduler.every '5s' do
  agent.submit_info
end

scheduler.join
