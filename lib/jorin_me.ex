defmodule JorinMe do
  require Logger
  alias JorinMe.Content
  use Phoenix.Component
  import Phoenix.HTML

  @output_dir "./output"
  File.mkdir_p!(@output_dir)

  def site_title() do
    "jorin.me"
  end

  def site_description() do
    "Jorin's personal blog on building data and communication systems"
  end

  def site_author() do
    "Jorin Vogel"
  end

  def site_url() do
    "https://jorin.me"
  end

  def format_iso_date(date) do
    date
    |> DateTime.new!(~T[06:00:00])
    |> DateTime.to_iso8601()
  end

  def format_post_date(date) do
    Calendar.strftime(date, "%b %-d, %Y")
  end

  def count_words(post) do
    body_count = post.body |> String.split() |> Enum.count()
    description_count = post.description |> String.split() |> Enum.count()
    body_count + description_count
  end

  def newsletter(assigns) do
    ~H"""
    <div class="newsletter-section">
      <form action="https://buttondown.email/api/emails/embed-subscribe/jorin" method="post" target="popupwindow" onsubmit="window.open('https://buttondown.email/jorin', 'popupwindow')" class="embeddable-buttondown-form">
        <label for={@input_id}>Get new posts in your inbox:</label>
        <input type="email" name="email" id={@input_id} placeholder="email" />
        <input type="submit" value="subscribe" />
      </form>
    </div>
    """
  end

  def post(assigns) do
    ~H"""
    <.layout title={"#{@post.title} — #{site_title()}"} description={@post.description} og_type="article" route={@post.route} date={@post.date} keywords={@post.keywords} wordcount={count_words(@post)}>
      <.newsletter input_id="bd-email-top" />
      <div class="post-header">
        <small class="post-meta"><span class="author">Jorin Vogel - </span><%= format_post_date(@post.date) %></small>
        <a href={@post.route}>
          <h1><%= @post.title %></h1>
        </a>
      </div>
      <article class="post-content">
        <p><%= @post.description %></p>
        <%= raw @post.body %>
      </article>
      <.newsletter input_id="bd-email-bottom" />
      <div class="post-footer">
        <img src="/images/vo.png" alt="Jorin Vogel" class="avatar" width="64px" height="64px" style="padding-left: 4px; padding-bottom: 4px; background: black;" />
        <p>
        Thanks for reading!
        <br />
        My name is Jorin and I am currently building a new feedback tool.
        <br />
        Feel free to send me a <a href="mailto:hi@jorin.me">mail</a> or talk to me on <a href="https://twitter.com/intent/user?screen_name=jorinvo">twitter</a>.
          </p>
        </div>
        <footer>
          use github to
          <a href={"https://github.com/jorinvo/me/edit/master/#{@post.md_path}"}>
            edit the post source
          </a>
          or
          <a href="https://github.com/jorinvo/me/issues">give me feedback</a>
        </footer>
    </.layout>
    """
  end

  def index(assigns) do
    ~H"""
    <.layout title={site_title()} description={site_description()} route="/" og_type="website">
      <.newsletter input_id="bd-email-top" />
      <div class="posts">
        <a :for={post <- @posts} href={post.route} class="post-link alternate">
          <div class="post">
            <small class="post-meta"><%= format_post_date(post.date) %></small>
            <h2 class="post-title"><%= post.title %></h2>
            <div class="post-summary"><%= post.description %></div>
          </div>
        </a>
      </div>
      <.newsletter input_id="bd-email-bottom" />
      <footer>
        use github to <a href="https://github.com/jorinvo/me/issues">give me feedback</a>
      </footer>
    </.layout>
    """
  end

  def page(assigns) do
    ~H"""
    <.layout title={"#{@page.title} — #{site_title()}"} description={@page.description} og_type="website" route={@page.route}>
      <div class="post-header">
        <a href={@page.route}>
          <h1><%= @page.title %></h1>
        </a>
      </div>
      <article class="post-content">
        <%= raw @page.body %>
      </article>
        <footer>
          use github to
          <a href={"https://github.com/jorinvo/me/edit/master/#{@page.md_path}"}>
            edit the page source
          </a>
          or
          <a href="https://github.com/jorinvo/me/issues">give me feedback</a>
        </footer>
    </.layout>
    """
  end

  def layout(assigns) do
    ~H"""
    <!DOCTYPE html>
      <html lang="en">
        <head>
          <meta charset="utf-8" />
          <title><%= @title %></title>
          <meta name="description" content={@description} />
          <meta name="author" content={site_author()} />
          <meta http-equiv="X-UA-Compatible" content="IE=edge" />
          <meta name="viewport" content="width=device-width, initial-scale=1" />
          <link href="/index.xml" rel="alternate" type="application/rss+xml" title={site_title()} />
          <meta name="ROBOTS" content="INDEX, FOLLOW" />
          <meta property="og:title" content={@title} />
          <meta property="og:description" content={@description} />
          <meta property="og:type" content={@og_type} />
          <meta property="og:url" content={"#{site_url()}#{@route}"}>
          <meta name="twitter:card" content="summary" />
          <meta name="twitter:title" content={@title} />
          <meta name="twitter:description" content={@description} />
          <meta itemprop="name" content={@title} />
          <meta itemprop="description" content={@description} />
          <%= if @og_type == "article" do %>
            <meta itemprop="datePublished" content={format_iso_date(@date)} />
            <meta itemprop="dateModified" content={format_iso_date(@date)} />
            <meta itemprop="wordCount" content={@wordcount} />
            <meta itemprop="keywords" content={Enum.join(@keywords, ",")} />
            <meta property="article:author" content={site_author()} />
            <meta property="article:section" content="Software" />
            <%= for keyword <- @keywords do %>
              <meta property="article:tag" content={keyword} />
            <% end %>
            <meta property="article:published_time" content={format_iso_date(@date)} />
            <meta property="article:modified_time" content={format_iso_date(@date)} />
          <% end %>
          <link rel="stylesheet" href="/assets/app.css" />
          <script type="text/javascript" src="/assets/app.js" />
        </head>
        <body>
          <header>
            <div class="social">
              <a href="/">Posts</a>
              <a href="/about">About</a>
              <a type="application/rss+xml" href="/index.xml">RSS</a>
              <a href="https://github.com/jorinvo">Github</a>
              <a href="https://twitter.com/jorinvo">Twitter</a>
              <a rel="me" href="https://mas.to/@jorin">Mastodon</a>
            </div>
          </header>
          <%= render_slot(@inner_block) %>
        </body>
      </html>
    """
  end

  def build_pages() do
    posts = Content.all_posts()
    about_page = Content.about_page()
    render_file("index.html", index(%{posts: posts}))
    render_file(about_page.html_path, page(%{page: about_page}))

    for post <- posts do
      render_file(post.html_path, post(%{post: post}))
    end

    :ok
  end

  def render_file(path, rendered) do
    Logger.info("Rendering #{path}")
    safe = Phoenix.HTML.Safe.to_iodata(rendered)
    dir = Path.dirname(path)
    output = Path.join([@output_dir, path])

    if dir != "." do
      File.mkdir_p!(Path.join([@output_dir, dir]))
    end

    File.write!(output, safe)
  end

  def build_all() do
    Logger.info("Ensure output directory")
    File.mkdir_p!("output")
    Logger.info("Copying static files")
    File.cp_r!("static", "output/")
    Logger.info("Building pages")

    {micro, :ok} =
      :timer.tc(fn ->
        build_pages()
      end)

    ms = micro / 1000
    Logger.info("Pages built in #{ms}ms")
    Logger.info("Running tailwind")
    # Using mix task because it install the binaries if not available yet
    Mix.Tasks.Tailwind.run(["default", "--minify"])
    Logger.info("Running esbuild")
    Mix.Tasks.Esbuild.run(["default", "--minify"])
  end
end
