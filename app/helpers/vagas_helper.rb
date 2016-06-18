module VagasHelper
  def icones_situacao_vaga
    {
      'a' => 'ok-sign',
      'c' => 'exclamation-sign',
      'n' => 'minus-sign',
      'r' => 'share',
      's' => 'remove-sign'
    }
  end

  def classe_situacao_vaga
    {
      'a' => 'alert-success',
      'c' => 'alert-warning',
      'n' => 'alert-danger',
      'r' => 'alert-info',
      's' => 'alert-danger'
    }
  end
end
