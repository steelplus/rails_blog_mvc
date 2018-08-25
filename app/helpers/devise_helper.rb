module DeviseHelper
  def devise_error_messages!
    return "" if resource.errors.empty?

    html = <<-EOF
      <article class="message is-warning">
      <div class="message-header">
        <p>Warning</p>
      </div>
      <div class="message-body">
    EOF
    messages = resource.errors.full_messages.each do |errmsg|
      html += <<-EOF
        <li>#{errmsg}</li>
      EOF
    end
    html += <<-EOF
      </div>
    </article>
    EOF
    html.html_safe
  end

  def devise_error_messages?
    resource.errors.empty? ? false : true
  end
end
