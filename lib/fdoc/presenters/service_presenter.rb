# An HtmlPresenter for Fdoc::Service
class Fdoc::ServicePresenter < Fdoc::BasePresenter
  attr_reader :service

  def initialize(service, options = {})
    super(options)
    @service = service
  end

  def to_html
    render_erb('service.html.erb')
  end

  def name_as_link(options = {})
    path = service.meta_service ? index_path(slug_name) : index_path
    '<a href="%s">%s %s</a>' % [ path, options[:prefix], service.name ]
  end

  def slug_name
    service.name.downcase.gsub(/[ \/]/, '_')
  end

  def url(extension = ".html")
    '%s-%s%s' % [ @endpoint.path, @endpoint.verb, extension ]
  end

  def endpoints
    if !@endpoints
      @endpoints = []
      prefix = nil

      service.endpoints.sort_by(&:endpoint_path).each do |endpoint|
        presenter = Fdoc::EndpointPresenter.new(endpoint, options)
        presenter.service_presenter = self
        presenter

        current_prefix = presenter.prefix

        @endpoints << [] if prefix != current_prefix
        @endpoints.last << presenter

        prefix = current_prefix
      end
    end

    @endpoints
  end


  def html_endpoints
    if !@endpoints
      @endpoints = []
      prefix = nil

      service.endpoints.sort_by(&:endpoint_path).each do |endpoint|
        presenter = Fdoc::HTML::EndpointPresenter.new(endpoint, options)
        presenter.service_presenter = self
        presenter

        current_prefix = presenter.prefix

        @endpoints << [] if prefix != current_prefix
        @endpoints.last << presenter

        prefix = current_prefix
      end
    end

    @endpoints
  end


  def description
    render_markdown(service.description)
  end

  def discussion
    render_markdown(service.discussion)
  end
end
