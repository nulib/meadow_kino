defmodule Meadow.Kino.DBConnectionCell do
  @moduledoc false

  use Kino.JS, assets_path: "lib/assets/db_connection_cell"
  use Kino.JS.Live
  use Kino.SmartCell, name: "Meadow: DB Connection"

  @impl true
  def init(attrs, ctx) do
    fields = %{
      "variable" => Kino.SmartCell.prefixed_var_name("conn", attrs["variable"])
    }

    ctx =
      assign(ctx,
        fields: fields
      )

    {:ok, ctx} |> IO.inspect(label: "init")
  end

  @impl true
  def handle_connect(ctx) do
    {:ok, %{fields: ctx.assigns.fields}, ctx} |> IO.inspect(label: "handle_connect")
  end

  @impl true
  def handle_event("update_field", %{"field" => field, "value" => value}, ctx) do
    updated_fields = to_updates(ctx.assigns.fields, field, value)
    ctx = update(ctx, :fields, &Map.merge(&1, updated_fields))

    broadcast_event(ctx, "update", %{"fields" => updated_fields})

    {:noreply, ctx} |> IO.inspect(label: "handle_event/update_field")
  end

  defp to_updates(fields, "variable", value) do
    if Kino.SmartCell.valid_variable_name?(value) do
      %{"variable" => value}
    else
      %{"variable" => fields["variable"]}
    end
    |> IO.inspect(label: "to_updates")
  end

  @impl true
  def to_attrs(%{assigns: %{fields: fields}}), do: fields

  @impl true
  def to_source(attrs) do
    IO.inspect(attrs, label: "to_source")

    source =
      quote do
        require Kino.RPC
        node = String.to_atom(System.fetch_env!("LB_MEADOW_NODE"))
        Node.set_cookie(node, String.to_atom(System.fetch_env!("LB_MEADOW_COOKIE")))

        db_opts =
          Kino.RPC.eval_string(
            node,
            ~S"""
            Application.get_env(:meadow, Meadow.Repo)
            |> Keyword.take([:hostname, :port, :username, :password, :database])
            """,
            file: __ENV__.file
          )

        {:ok, unquote(quoted_var(attrs["variable"]))} = Kino.start_child({Postgrex, db_opts})
      end

    Kino.SmartCell.quoted_to_string(source)
  end

  defp quoted_var(string), do: {String.to_atom(string), [], nil}
end
