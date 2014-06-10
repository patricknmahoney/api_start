module SinatraUtils
  def h_escape(text)
    Rack::Utils.escape_html(text)
  end
end