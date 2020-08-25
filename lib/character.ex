defmodule CommonsPub.Core.Character do

  use Pointers.Mixin,
    otp_app: :cpub_core,
    source: "cpub_core_character"

  alias Pointers.Changesets
  require Pointers.Changesets
  alias CommonsPub.Core.Character
  alias Ecto.Changeset
  
  mixin_schema do
    field :username, :string
    field :username_hash, :string
  end

  @cast [:username]
  @required @cast
  @username_format ~r(^[a-zA-Z_][a-zA-Z0-9_]{2,30}$)

  def changeset(char \\ %Character{}, attrs) do
    config = Changesets.config(Changesets.verb(char), [])
    char
    |> Changesets.cast(attrs, config, @cast)
    |> Changesets.validate_required(attrs, config, @required)
    |> Changesets.validate_format(attrs, config, :username, :username_format, @username_format)
    |> Changesets.replicate_map_valid_change(:username, :username_hash, &hash/1)
    |> Changeset.unique_constraint(:username)
    |> Changeset.unique_constraint(:username_hash)
  end

  def hash(string), do: Base.encode64(:crypto.hash(:blake2b, string), padding: false)

  def redact(%Character{}=char), do: Changeset.change(char, username: nil)

end
defmodule CommonsPub.Core.Character.Migration do

  import Ecto.Migration
  import Pointers.Migration
  alias CommonsPub.Core.Character

  @character_table Character.__schema__(:source)

  def migrate_character(index_opts \\ [], dir \\ direction())

  def migrate_character(index_opts, :up) do
    index_opts = Keyword.put_new(index_opts, :using, "hash")
    create_mixin_table(Character) do
      add :username, :text
      add :username_hash, :text, null: false
    end
    create_if_not_exists(unique_index(@character_table, [:username], index_opts))
    create_if_not_exists(unique_index(@character_table, [:username_hash], index_opts))
  end

  def migrate_character(index_opts, :down) do
    drop_if_exists(unique_index(@character_table, [:username], index_opts))
    drop_if_exists(unique_index(@character_table, [:username_hash], index_opts))
    drop_mixin_table(Character)
  end

end
