module VagasHelper
  def situacao_vaga
    {
      "a" => "Aberta",
      "o" => "Ocupada",
      "r" => "Redistribuída",
      "s" => "Substituto",
      "c" => "Concurso",
      "n" => "Nomeação"
    }
  end
end
