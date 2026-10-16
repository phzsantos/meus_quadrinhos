# frozen_string_literal: true

module WelcomeHelper
  READING_ACTIVITY_DAY_LABELS = ["", "Seg", "", "Qua", "", "Sex", ""].freeze
  READING_ACTIVITY_MONTHS = ["Jan", "Fev", "Mar", "Abr", "Mai", "Jun", "Jul", "Ago", "Set", "Out", "Nov", "Dez"].freeze
  READING_ACTIVITY_FULL_MONTHS = [
    "janeiro",
    "fevereiro",
    "março",
    "abril",
    "maio",
    "junho",
    "julho",
    "agosto",
    "setembro",
    "outubro",
    "novembro",
    "dezembro",
  ].freeze

  def reading_activity_day_labels
    READING_ACTIVITY_DAY_LABELS
  end

  def reading_activity_month_name(month)
    return if month.blank?

    READING_ACTIVITY_MONTHS[month - 1]
  end

  def reading_activity_summary(total)
    case total
    when 0
      safe_join([tag.strong("Nenhum"), " quadrinho lido no último ano"])
    when 1
      safe_join([tag.strong(1), " quadrinho lido no último ano"])
    else
      safe_join([tag.strong(total), " quadrinhos lidos no último ano"])
    end
  end

  def reading_activity_tooltip(day)
    date = day[:date]
    formatted = "#{date.day} de #{READING_ACTIVITY_FULL_MONTHS[date.month - 1]} de #{date.year}"

    case day[:count]
    when 0
      safe_join([tag.strong("Nenhum"), " quadrinho lido em ", formatted])
    when 1
      safe_join([tag.strong(1), " quadrinho lido em ", formatted])
    else
      safe_join([tag.strong(day[:count]), " quadrinhos lidos em ", formatted])
    end
  end
end
