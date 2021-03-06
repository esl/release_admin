defmodule Buildex.API.RepositoryTest do
  use Buildex.API.DataCase
  import Buildex.API.Factory

  alias Buildex.API.{Repo, Repository}

  describe "validations" do
    test "validates uniqueness of repository url" do
      attrs = %{
        repository_url: "https://github.com/jeremyjh/dialyxir",
        polling_interval: 60,
        user_id: 1
      }

      insert(:repository, repository_url: "https://github.com/jeremyjh/dialyxir")

      assert {:error, reason} =
               %Repository{}
               |> Repository.changeset(attrs)
               |> Repo.insert()

      assert %{repository_url: ["has already been taken"]} = errors_on(reason)
    end

    test "validates repository_url is required" do
      assert {:error, reason} =
               %Repository{}
               |> Repository.changeset(%{})
               |> Repo.insert()

      assert %{repository_url: ["can't be blank"]} = errors_on(reason)
    end

    test "validates polling_interval is required" do
      assert {:error, reason} =
               %Repository{}
               |> Repository.changeset(%{})
               |> Repo.insert()

      assert %{polling_interval: ["can't be blank"]} = errors_on(reason)
    end

    test "validates adapter is must be supported" do
      assert {:error, reason} =
               %Repository{}
               |> Repository.changeset(%{adapter: "gitlab"})
               |> Repo.insert()

      assert %{adapter: ["is invalid"]} = errors_on(reason)
    end
  end
end
