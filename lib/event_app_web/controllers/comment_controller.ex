defmodule EventAppWeb.CommentController do
  use EventAppWeb, :controller

  alias EventApp.Comments
  alias EventApp.Comments.Comment
  alias EventApp.Events

  plug :fetch_comment when action in [:show, :edit, :update, :delete]
  plug :require_owner when action in [:edit, :update, :delete]
  
  def fetch_comment(conn, _args) do
    id = conn.params["id"]
    comment = Comments.get_comment!(id)

    event_id = Map.get(comment, :event_id)
    event = Events.get_event!(event_id)

    conn
    |> assign(:event, event)
    |> assign(:comment, comment)
  end

  def index(conn, _params) do
    comments = Comments.list_comments()
    render(conn, "index.html", comments: comments)
  end

  def new(conn, _params) do
    changeset = Comments.change_comment(%Comment{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"comment" => comment_params}) do
    IO.inspect(current_user_id(conn))
    comment_params = comment_params
    |> Map.put("user_id", current_user_id(conn))
    IO.inspect(comment_params)
    case Comments.create_comment(comment_params) do
      {:ok, comment} ->
        conn
        |> put_flash(:info, "Comment created successfully.")
        |> redirect(to: Routes.comment_path(conn, :show, comment))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    comment = Comments.get_comment!(id)
    render(conn, "show.html", comment: comment)
  end

  def edit(conn, %{"id" => id}) do
    comment = Comments.get_comment!(id)
    changeset = Comments.change_comment(comment)
    render(conn, "edit.html", comment: comment, changeset: changeset)
  end

  def update(conn, %{"id" => id, "comment" => comment_params}) do
    comment = Comments.get_comment!(id)

    case Comments.update_comment(comment, comment_params) do
      {:ok, comment} ->
        conn
        |> put_flash(:info, "Comment updated successfully.")
        |> redirect(to: Routes.comment_path(conn, :show, comment))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", comment: comment, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    comment = Comments.get_comment!(id)
    {:ok, _comment} = Comments.delete_comment(comment)

    conn
    |> put_flash(:info, "Comment deleted successfully.")
    |> redirect(to: Routes.comment_path(conn, :index))
  end

  def require_owner(conn, _args) do
    user = conn.assigns[:current_user]
    comment = conn.assigns[:comment]
    event = conn.assigns[:event]

    if (user.id == event.user_id or user.id == comment.user_id) do
      conn
    else
      conn
      |> put_flash(:error, "You can't delete this comment")
      |> redirect(to: Routes.event_path(conn, :show, event.id))
      |> halt()
    end
  end

end
