module VagasHelper
  def situacao_vaga(codigo)
    {
      "a" => "Aberta",
      "o" => "Ocupada",
      "r" => "Redistribuída",
      "s" => "Substituto",
      "c" => "Concurso",
      "n" => "Nomeação"
    }[codigo]
  end
end
