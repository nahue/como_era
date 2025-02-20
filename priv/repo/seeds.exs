# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     ComoEra.Repo.insert!(%ComoEra.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias ComoEra.Bands.Band
alias ComoEra.Songs.Song
alias ComoEra.Repo

foo_fighters = Repo.insert!(%Band{name: "Foo Fighters"})
stone_temple_pilots = Repo.insert!(%Band{name: "Stone Temple Pilots"})

Repo.insert!(%Song{name: "Everlong", band_id: foo_fighters.id})
Repo.insert!(%Song{name: "Learn to Fly", band_id: foo_fighters.id})
Repo.insert!(%Song{name: "Monkey Wrench", band_id: foo_fighters.id})
Repo.insert!(%Song{name: "Plush", band_id: stone_temple_pilots.id})
Repo.insert!(%Song{name: "Interstate Love Song", band_id: stone_temple_pilots.id})
