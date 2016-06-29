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

  def tipo_certame
    {
      'concurso' => 'Concurso Público',
      'processo' => 'Processo Seletivo Simplificado'
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

  def unicode_translate(original)
    # O applet da Imprensa Nacional não aceita caracteres unicode.
    # O RTF gerado tem caracteres no formato "\u123\'3f", mas o
    # formato aceito é "\'f1".
    # http://unicodelookup.com/
    # http://www.utf8-chartable.de/
    # http://stackoverflow.com/a/8132729/3059369
    mapa = {
      "u170\\'3f" => "'aa", # ª
      "u186\\'3f" => "'ba", # º
      "u192\\'3f" => "'c0", # À
      "u193\\'3f" => "'c1", # Á
      "u194\\'3f" => "'c2", # Â
      "u195\\'3f" => "'c3", # Ã
      "u199\\'3f" => "'c7", # Ç
      "u201\\'3f" => "'c9", # É
      "u202\\'3f" => "'ca", # Ê
      "u205\\'3f" => "'cd", # Í
      "u211\\'3f" => "'d3", # Ó
      "u212\\'3f" => "'d4", # Ô
      "u213\\'3f" => "'d5", # Õ
      "u218\\'3f" => "'da", # Ú
      "u224\\'3f" => "'e0", # à
      "u225\\'3f" => "'e1", # á
      "u226\\'3f" => "'e2", # â
      "u227\\'3f" => "'e3", # ã
      "u231\\'3f" => "'e7", # ç
      "u233\\'3f" => "'e9", # é
      "u234\\'3f" => "'ea", # ê
      "u237\\'3f" => "'ed", # í
      "u243\\'3f" => "'f3", # ó
      "u244\\'3f" => "'f4", # ô
      "u245\\'3f" => "'f5", # õ
      "u250\\'3f" => "'fa" # ú
    }

    re = Regexp.new(mapa.keys.map { |x| Regexp.escape(x) }.join('|'))

    alterado = original.gsub(re, mapa)
  end
end
