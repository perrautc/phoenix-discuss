defmodule Discuss.TopicController do
  use Discuss.Web, :controller

  alias Discuss.Topic

  @moduledoc """
  Controller for topics
  """
  def index(conn, _params) do
    topics = 
      Topic
      |> order_by([c], [c.title])
      |> Repo.all()

    render conn, "index.html", topics: topics
  end

  def new(conn, _params) do
    changeset = Topic.changeset(%Topic{}, %{})

    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"topic" => topic}) do
    changeset = Topic.changeset(%Topic{}, topic)

    case Repo.insert(changeset) do
      {:ok, %Discuss.Topic{title: title}} ->
        conn
        |> put_flash(:info, "Topic Created #{title}")
        |> redirect(to: topic_path(conn, :index))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Found Error")
        |> render("new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => topic_id}) do
    topic = Repo.get(Topic, topic_id)
    changeset = Topic.changeset(topic)

    render conn, "edit.html", changeset: changeset, topic: topic
  end

  def update(conn, %{"id" => topic_id, "topic"=> topic }) do
    old_topic = Repo.get(Topic, topic_id)
    changeset = 
      Topic
      |> Repo.get(topic_id)
      |> Topic.changeset(topic)

    case Repo.update(changeset) do
      {:ok, %Discuss.Topic{title: title}} ->
        conn
        |> put_flash(:info, "Topic Updated #{title}")
        |> redirect(to: topic_path(conn, :index))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Update Failed")
        |> render("edit.html", changeset: changeset, topic: old_topic)
    end
  end

  def delete(conn, %{"id" => topic_id}) do
    Topic
    |> Repo.get!(topic_id)
    |> Repo.delete!
    
    conn
    |> put_flash(:info, "Topic Deleted")
    |> redirect(to: topic_path(conn, :index))
  end
end