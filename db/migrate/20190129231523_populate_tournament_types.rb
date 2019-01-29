class PopulateTournamentTypes < ActiveRecord::Migration[5.1]
  def change
    tt = TournamentType.find_or_initialize_by(id:1)
    tt.name = 'Store Event'
    tt.save
    tt = TournamentType.find_or_initialize_by(id:2)
    tt.name = 'National Championship'
    tt.save 
    tt = TournamentType.find_or_initialize_by(id:3)
    tt.name = 'Hyperspace Trial'
    tt.save
    tt = TournamentType.find_or_initialize_by(id:4)
    tt.name = 'Hyperspace Cup'
    tt.save
    tt = TournamentType.find_or_initialize_by(id:5)
    tt.name = 'System Open'
    tt.save
    tt = TournamentType.find_or_initialize_by(id:6)
    tt.name = 'World Championship'
    tt.save
    tt = TournamentType.find_or_initialize_by(id:7)
    tt.name = 'Casual Event'
    tt.save
    tt = TournamentType.find_or_initialize_by(id:8)
    tt.name = 'Other'
    tt.save
  end
end
