module VagasHelper
  def icones_situacao
    {
      "a" => "ok-sign",
      "c" => "exclamation-sign",
      "c,s" => "exclamation-sign",
      "n" => "minus-sign",
      "o" => "remove-sign",
      "r" => "share",
      "s" => "remove-sign"
    }
  end

  def classe_situacao
    {
      "a" => "alert-success",
      "c" => "alert-warning",
      "c,s" => "alert-warning",
      "n" => "alert-danger",
      "o" => "alert-danger",
      "r" => "alert-info",
      "s" => "alert-danger"
    }
  end
end
