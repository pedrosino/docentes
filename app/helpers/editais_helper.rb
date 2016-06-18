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
end
