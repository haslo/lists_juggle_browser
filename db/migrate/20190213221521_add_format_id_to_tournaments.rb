class AddFormatIdToTournaments < ActiveRecord::Migration[5.1]
  def up
    rename_column :tournaments, :format, :formatString
    add_reference :tournaments, :format, foreign_key: true

    Tournament.where(formatString: "1").update_all(format_id:1)
    Tournament.where(formatString: "2").update_all(format_id:2)
    Tournament.where(formatString: "3").update_all(format_id:3)
    Tournament.where(formatString: "4").update_all(format_id:4)
    Tournament.where(formatString: "34").update_all(format_id:34)

    remove_column :tournaments, :formatString
  end

  def down
    add_column :tournaments, :formatString

    Tournament.where(format_id: 1).update_all(formatString:"1")
    Tournament.where(format_id: 2).update_all(formatString:"2")
    Tournament.where(format_id: 3).update_all(formatString:"3")
    Tournament.where(format_id: 4).update_all(formatString:"4")
    Tournament.where(format_id: 34).update_all(formatString:"34")

    remove_column :tournaments, :format_id
    rename_column :tournaments, :formatString, :format
  end
end
