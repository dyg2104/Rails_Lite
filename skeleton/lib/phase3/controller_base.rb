require_relative '../phase2/controller_base'
require 'active_support/core_ext'
require 'erb'

module Phase3
  class ControllerBase < Phase2::ControllerBase
    # use ERB and binding to evaluate templates
    # pass the rendered html to render_content
    def render(template_name)

      original_name = self.class.to_s
      break_name = original_name.index("Controller")
      modified_name = original_name[0...break_name].downcase + "_" +
                      original_name[break_name..-1].downcase

      template_contents = File.read("views/#{modified_name}/#{template_name}.html.erb")
      template_erb = ERB.new(template_contents)
      binding
      render_content(template_erb.result(binding), "text/html")
    end
  end
end
