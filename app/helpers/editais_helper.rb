module EditaisHelper
  def cidade(campus)
    {
      'Educação Física' => 'Uberlândia',
      'Glória' => 'Uberlândia',
      'Monte Carmelo' => 'Monte Carmelo',
      'Patos de Minas' => 'Patos de Minas',
      'Pontal' => 'Ituiutaba',
      'Santa Mônica' => 'Uberlândia',
      'Umuarama' => 'Uberlândia'
    }[campus]
  end

  def icones_situacao_edital
    {
      'uni' => 'envelope-o',
      'apr' => 'check',
      'pro' => 'external-link-square',
      'pub' => 'newspaper-o',
      'enc' => 'check-square-o'
    }
  end

  def classe_situacao_edital
    {
      'uni' => 'alert-warning',
      'apr' => 'alert-warning',
      'pro' => 'alert-warning',
      'pub' => 'alert-info',
      'enc' => 'alert-success'
    }
  end

  def para_unidade(nome)
    if nome.starts_with?('I')
      "o " + nome
    else
      "a " + nome
    end
  end

  def vencimento_basico(regime)
    {
      '20' => 2018.77,
      '40' => 2814.01,
      'DE' => 4014
    }[regime]
  end

  def retribuicao_titulacao(regime, titulacao)
    {
      '20' => [0, 86.16, 155.08, 480.01, 964.82],
      '40' => [0, 168.29, 370.72, 985.69, 2329.40],
      'DE' => [0, 352.98, 616.83, 1931.98, 4625.50]
    }[regime][titulacao]
  end

  def classes_superior
    {
      0 => 'Auxiliar',
      1 => 'Auxiliar',
      2 => 'Auxiliar',
      3 => 'Assistente A',
      4 => 'Adjunto A'
    }
  end

  def titulos
    {
      0 => 'Graduação',
      1 => 'Aperfeiçoamento',
      2 => 'Especialização',
      3 => 'Mestrado',
      4 => 'Doutorado'
    }
  end
end
