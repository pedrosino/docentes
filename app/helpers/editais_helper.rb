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
end
