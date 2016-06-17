module ApplicationHelper
  def bootstrap_class_for(flash_type)
    {
      success: 'alert-success',
      danger: 'alert-danger',
      warning: 'alert-warning',
      info: 'alert-info',

      # For devise
      notice: 'alert-success',
      alert: 'alert-danger',

      recaptcha_error: 'alert-danger'
    }[flash_type.to_sym] || flash_type.to_s
  end

  def regime_de_trabalho_longo(codigo)
    {
      '20' => '20 (vinte) horas semanais',
      '40' => '40 (quarenta) horas semanais',
      'DE' => 'Dedicação Exclusiva'
    }[codigo]
  end

  def regime_de_trabalho
    {
      '20' => '20 horas',
      '40' => '40 horas',
      'DE' => 'Dedicação Exclusiva'
    }
  end

  def lista_campus
    ['Educação Física', 'Glória', 'Monte Carmelo', 'Patos de Minas', 'Pontal', 'Santa Mônica', 'Umuarama']
  end

  def vagas_efetivo
    ['Aposentadoria', 'Exoneração', 'Falecimento', 'Redistribuição', 'Remoção', 'Vacância do cargo', 'Vaga nova (especificar)']
  end

  def vagas_substituto
    ['Licença maternidade', 'Licença médica', 'Afastamento para pós-graduação', 'Cessão', 'Cargo de Reitor', 'Cargo de Pró-Reitor']
  end

  def tipos_vaga
    {
      'Efetivos' => vagas_efetivo,
      'Substitutos' => vagas_substituto
    }
  end

  def icon_reverse(text, icon)
    text.html_safe + ' ' + content_tag(:i, '', class: "fa fa-#{icon}")
  end

  def glyphicon(icon)
    content_tag(:span, '', class: "glyphicon glyphicon-#{icon}")
  end
end
