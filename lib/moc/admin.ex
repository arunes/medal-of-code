defmodule Moc.Organization do
  defstruct [
    :id,
    :provider,
    :external_id,
    :total_projects,
    :total_repos,
    :total_active_repos,
    :total_prs,
    :total_reviews,
    :total_comments,
    :inserted_at
  ]
end

defmodule Moc.Admin do
  import Ecto.Query
  alias Moc.Organization
  alias Moc.Repo
  alias Moc.Schema

  def get_organization_list() do
    query_organizations() |> Repo.all()
  end

  # Queries
  defp query_organizations() do
    from(org in Schema.Organization,
      left_join: prj in assoc(org, :projects),
      left_join: rp in assoc(prj, :repositories),
      left_join: pr in assoc(rp, :pull_requests),
      left_join: prr in assoc(pr, :reviews),
      left_join: prc in assoc(pr, :comments),
      group_by: [org.id, org.provider, org.external_id, org.inserted_at],
      select: %Organization{
        id: org.id,
        provider: org.provider,
        external_id: org.external_id,
        total_projects: count(fragment("DISTINCT ?", prj.id)),
        total_repos: count(fragment("DISTINCT ?", rp.id)),
        total_active_repos:
          count(fragment("DISTINCT(CASE ? WHEN 1 THEN ? ELSE NULL END)", rp.sync_enabled, rp.id)),
        total_prs: count(fragment("DISTINCT ?", pr.id)),
        total_reviews: count(fragment("DISTINCT ?", prr.id)),
        total_comments: count(fragment("DISTINCT ?", prc.id)),
        inserted_at: org.inserted_at
      },
      order_by: org.external_id
    )
  end
end
