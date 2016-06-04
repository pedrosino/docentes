module ApplicationHelper
  def bootstrap_class_for(flash_type)
    {
      success: "alert-success",
      danger: "alert-danger",
      warning: "alert-warning",
      info: "alert-info",

      # For devise
      notice: "alert-success",
      alert: "alert-danger",

      recaptcha_error: "alert-danger",
    }[flash_type.to_sym] || flash_type.to_s
  end

  def regime_de_trabalho(codigo)
    {
      "20" => "20 (vinte) horas semanais",
      "40" => "40 (quarenta) horas semanais",
      "DE" => "Dedicação Exclusiva"
    }[codigo]
  end
end
