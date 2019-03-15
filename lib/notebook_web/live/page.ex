defmodule NotebookWeb.PageLive do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
      <h2>notebook</h2>

      <%= for cell <- @cells do %>
        <%= if cell[:eval_result] do %>
          <div>
            <code>
              <%= cell[:text] || "" %>
            </code>
          </div>
        <div>
          <pre>
            <code>
              <%= cell[:eval_result] || "" %>
            </code>
          </pre>
        </div>
        <% else %>
          <div>
            <code>
            <%= cell[:text] || "" %>
            </code>
          </div>
        <% end %>
      <% end %>

      <textarea phx-keyup="update_cell" placeholder="# any elixir code, like `1 + 1`"></textarea>

      <button phx-click="evaluate">Eval</button>

    """
  end

  def mount(_session, socket) do
    {:ok, assign(socket, cells: [], bindings: [], env: [])}
  end

  def handle_event("update_cell", text, socket) do
    {:noreply, assign(socket, input: text)}
  end

  def handle_event("evaluate", _value, socket) do
    cells = socket.assigns[:cells]

    {evaled, bindings, env} =
      eval(socket.assigns[:input], socket.assigns[:bindings], socket.assigns[:env])

    newcell = %{
      text: socket.assigns[:input],
      eval_result: inspect(evaled),
      active: false
    }

    {:noreply, assign(socket, cells: cells ++ [newcell], bindings: bindings, env: env)}
  end

  def handle_event(e, v, socket) do
    {:noreply, socket}
  end

  def eval(expression, bindings, env) do
    try do
      quoted = Code.string_to_quoted!(expression)

      # this uses low-level eval_quoted/3,
      # defined in `elixir.erl`:
      # https://github.com/elixir-lang/elixir/blob/v1.5.2/lib/elixir/src/elixir.erl#L214-L217
      # this is in lieu of using `Code.eval_quoted/3`,
      # because that function does not
      # return the result environment, whereas the erl version does
      {result, bindings, new_env, _scope} =
        :elixir.eval_quoted(
          quoted,
          bindings,
          env
        )

      {result, bindings, new_env}
    rescue
      e -> e
    end
  end
end
