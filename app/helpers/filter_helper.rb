module FilterHelper

  def show_filter?(controller, action)
    %w[ships pilots ship_combos upgrades squadrons].include?(controller) && %w[index show].include?(action)
  end

  def preset_dates
    [
      ['', nil],
      [I18n.t('shared.filter_configurator.dates.wave_1'), Date.new(2012, 9, 14)],
      [I18n.t('shared.filter_configurator.dates.wave_2'), Date.new(2013, 2, 28)],
      [I18n.t('shared.filter_configurator.dates.wave_3'), Date.new(2013, 9, 12)],
      [I18n.t('shared.filter_configurator.dates.imperial_aces'), Date.new(2014, 3, 14)],
      [I18n.t('shared.filter_configurator.dates.wave_4'), Date.new(2014, 6, 26)],
      [I18n.t('shared.filter_configurator.dates.rebel_aces'), Date.new(2014, 9, 25)],
      [I18n.t('shared.filter_configurator.dates.wave_5'), Date.new(2014, 11, 26)],
      [I18n.t('shared.filter_configurator.dates.wave_6'), Date.new(2015, 2, 26)],
      [I18n.t('shared.filter_configurator.dates.wave_7'), Date.new(2015, 8, 25)],
      [I18n.t('shared.filter_configurator.dates.tfa_core'), Date.new(2015, 9, 4)],
      [I18n.t('shared.filter_configurator.dates.wave_8'), Date.new(2016, 3, 17)],
      [I18n.t('shared.filter_configurator.dates.imperial_veterans'), Date.new(2016, 6, 30)],
      [I18n.t('shared.filter_configurator.dates.deadeye_nerf'), Date.new(2016, 10, 17)],
      [I18n.t('shared.filter_configurator.dates.heroes_resistance'), Date.new(2016, 10, 27)],
      [I18n.t('shared.filter_configurator.dates.wave_9'), Date.new(2016, 11, 22)],
      [I18n.t('shared.filter_configurator.dates.rogue_one'), Date.new(2016, 12, 15)],
      [I18n.t('shared.filter_configurator.dates.wave_10'), Date.new(2017, 2, 2)],
      [I18n.t('shared.filter_configurator.dates.grand_nerfbat'), Date.new(2017, 3, 6)],
      [I18n.t('shared.filter_configurator.dates.today'), Date.today],
    ]
  end

  def preset_ranking_data
    [
      [I18n.t('shared.filter_configurator.data_uses.swiss'), 'swiss'],
      [I18n.t('shared.filter_configurator.data_uses.elimination'), 'elimination'],
      [I18n.t('shared.filter_configurator.data_uses.all'), 'all'],
    ]
  end

end
