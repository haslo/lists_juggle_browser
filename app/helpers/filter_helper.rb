module FilterHelper

  def show_filter?(controller, action)
    %w[ships pilots ship_combos upgrades squadrons].include?(controller) && %w[index show].include?(action)
  end

  def preset_dates
    [
      ['', nil],
      [I18n.t('shared.filter_configurator.dates.launch'), Date.new(2018, 9, 13)],
      [I18n.t('shared.filter_configurator.dates.wave_2'), Date.new(2018, 12,13)],
      [I18n.t('shared.filter_configurator.dates.jan_19_points_update'), Date.new(2019, 1, 28)],
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
