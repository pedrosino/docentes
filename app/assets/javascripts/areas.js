function ativa_didatica() {
  if($("#area_prova_didatica").is(":checked")) {
    $(".panel.didatica").show();
  } else {
    $(".panel.didatica").hide();
  }
}

function ativa_procedimental() {
  if($("#area_prova_procedimental").is(":checked")) {
    $(".panel.procedimental").show();
    $(".procedimental-esconder").show();
  } else {
    $(".panel.procedimental").hide();
    $(".procedimental-esconder").hide();
  }
}

function verifica_soma($objeto, $campo, $total, $tipo) {
  var soma = 0;
  var contar = 0;
  var find_input = "input[name*='" + $campo + "']";
  $($objeto).find(find_input).each(function() {
    var numero = ($(this).prop('id').split('_'))[3];
    var destroy = $("input[name='area[" + $tipo + "_attributes][" + numero + "][_destroy]']").val();
    // destroy vem como string "false" ou "1"
    if (destroy == "false") {
      soma += parseFloat($(this).val());
      contar += 1;
    }
  });
  if (contar < 2) {
    return -1;
  }
  return (soma == $total);
}

function verifica_proporcao($objeto) {
  var numero = ($objeto.prop('id').split('_'))[3];
  $maximo = $("input[name*='[titulos_attributes]["+numero+"][maximo]']").val();
  $individual = $("input[name*='[titulos_attributes]["+numero+"][valor]']").val();
  $correto = (($maximo % $individual) == 0);
  return $correto;
}

function erro_proporcao($objeto, $correto) {
  var numero = ($objeto.prop('id').split('_'))[3];
  $input_maximo = $("input[name*='[titulos_attributes]["+numero+"][maximo]']");
  if ($correto) {
    $input_maximo.siblings('p').html("");
    $input_maximo.closest('td').removeClass('alert alert-danger');
  } else {
    $input_maximo.siblings('p').html("A proporção entre a pontuação máxima e a pontuação individual não está correta!");
    $input_maximo.closest('td').addClass('alert alert-danger');
  }
}

function valida_inicial() {
  $("#inicial").find(":input.required").each(function(){
    if ($(this).val() == "") {
      alert($(this).prop('id'));
      return false;
    }
  });
  return true;
}

function valida_prova_escrita() {
  var confere = verifica_soma($(".criterios-escrita"),"valor", 100,"criterios");
  if (confere == -1) {
    $(".panel.panel-default.escrita>.panel-body>.mensagem-erro").addClass('alert alert-danger').
    html("Preencha pelo menos dois critérios!");
    return false;
  } else if (!confere) {
    $(".panel.panel-default.escrita>.panel-body>.mensagem-erro").addClass('alert alert-danger').
    html("A soma dos critérios não atinge 100 pontos!");
    return false;
  } else {
    $(".panel.panel-default.escrita>.panel-body>.mensagem-erro").removeClass('alert alert-danger').html("");
  }

  $("#escrita").find(":input.required").each(function() {
    if($(this).val() == "") {
      $(this).addClass("alert-danger");
      preenchidos = false;
    } else {
      $(this).removeClass("alert-danger");
    }
  });
  return true;
}

function valida_prova_didatica() {
  // Verifica a prova didática (pedagógica)
  var validado_didatica = true;
  var preenchidos = true;
  if ($("#area_prova_didatica").is(":checked")) {
    var confere = verifica_soma($(".criterios-didatica"),"valor", 100, "criterios");
    if (confere == -1) {
      $(".panel.panel-default.didatica>.panel-body>.mensagem-erro").addClass('alert alert-danger').html("Preencha pelo menos dois critérios!");
      validado_didatica = false;
    } else if (!confere) {
      $(".panel.panel-default.didatica>.panel-body>.mensagem-erro").addClass('alert alert-danger').html("A soma dos critérios não atinge 100 pontos!");
      validado_didatica = false;
    } else {
      $(".panel.panel-default.didatica>.panel-body>.mensagem-erro").removeClass('alert alert-danger').html("");
    }

    $(".didatica").find(":input.required").each(function() {
      if($(this).val() == "") {
        $(this).addClass("alert-danger");
        preenchidos = false;
      } else {
        $(this).removeClass("alert-danger");
      }
    });
  }

  // Verifica a prova procedimental
  var validado_procedimental = true;
  var duracao = true;
  if ($("#area_prova_procedimental").is(":checked")) {
    var confere = verifica_soma($(".criterios-procedimental"),"valor", 100, "criterios")
    if (confere == -1) {
      $(".panel.panel-default.procedimental>.panel-body>.mensagem-erro").addClass('alert alert-danger').html("Preencha pelo menos dois critérios!");
      validado_procedimental = false;
    } else if (!confere) {
      $(".panel.panel-default.procedimental>.panel-body>.mensagem-erro").addClass('alert alert-danger').html("A soma dos critérios não atinge 100 pontos!");
      validado_procedimental = false;
    } else {
      $(".panel.panel-default.procedimental>.panel-body>.mensagem-erro").removeClass('alert alert-danger').html("");
    }

    // Verifica se a duração foi preenchida
    $(".numeric.integer.optional.form-control").each(function(){
      if ($(this).val() == "") {
        $(this).parent().addClass("alert alert-danger");
        duracao = false;
      } else {
        $(this).parent().removeClass("alert alert-danger");
      }
    });

    $(".procedimental").find(":input.required").each(function() {
      if($(this).val() == "") {
        $(this).addClass("alert-danger");
        preenchidos = false;
      } else {
        $(this).removeClass("alert-danger");
      }
    });
  }

  // Impede o formulário de ser enviado
  if (!validado_didatica || !validado_procedimental || !duracao || !preenchidos) {
    return false;
  }
  return true;
}

function valida_titulos($this) {
  // Verificar soma de cada parte
  var validado_atividades = true;
  var confere_atividades = verifica_soma($(".table.atividades"),"maximo", $("input[name='maximo-atividades']").val(), "titulos");
  if (confere_atividades == -1) {
    $(".panel.panel-default.atividades>.panel-body>.mensagem-erro").addClass('alert alert-danger').html("Preencha pelo menos dois itens!");
    validado_atividades = false;
  } else if (!confere_atividades) {
    $(".panel.panel-default.atividades>.panel-body>.mensagem-erro").addClass('alert alert-danger').html("A soma dos itens não atinge a pontuação máxima!");
  } else {
    $(".panel.panel-default.atividades>.panel-body>.mensagem-erro").removeClass('alert alert-danger').html("");
  }

  var validado_producao = true;
  var confere_producao = verifica_soma($(".table.producao"),"maximo", $("input[name='maximo-producao']").val(), "titulos");
  if (confere_producao == -1) {
    $(".panel.panel-default.producao>.panel-body>.mensagem-erro").addClass('alert alert-danger').html("Preencha pelo menos dois itens!");
    validado_producao = false;
  } else if (!confere_producao) {
    $(".panel.panel-default.producao>.panel-body>.mensagem-erro").addClass('alert alert-danger').html("A soma dos itens não atinge a pontuação máxima!");
  } else {
    $(".panel.panel-default.producao>.panel-body>.mensagem-erro").removeClass('alert alert-danger').html("");
  }

  // Verifica proporções
  var validado_proporcao = true;
  $("input[name*='[maximo]'][name*='[titulos_attributes]']").each(function(){
    if (!verifica_proporcao($(this))) {
      validado_proporcao = false;
    }
  });

  // Verifica input "coautoria"
  var coautoria = true;
  if ($("#area_coautoria").val() == "") {
    $($("#area_coautoria")).addClass("alert-danger");
    coautoria = false;
  } else {
    $($("#area_coautoria")).removeClass("alert-danger");
  }

  var preenchidos = true;
  $("#titulos").find(":input.required").each(function() {
    if($(this).val() == "") {
      $(this).addClass("alert-danger");
      preenchidos = false;
    } else {
      $(this).removeClass("alert-danger");
    }
  });

  if (!validado_atividades || !validado_producao || !validado_proporcao || !coautoria || !preenchidos) {
    return false;
  }
  return true;
}

onPage('areas edit, areas update', function(){
  //---------------------------------------------------------
  //------------- Informações básicas da área ---------------
  //---------------------------------------------------------
  var qual = $("#area_qualif_prorrogar").parent("div");
  qual.hide();

  $("#area_prorrogar").change(function(){
    if($(this).is(":checked")) {
      qual.show();
      qual.prop("disabled", "");
    } else {
      qual.hide();
    }
  });

  $("#area_regime").on('change', function(){
    $tipo = $("#area_tipo").val();
    $regime = $(this).val();
    if ($tipo == 'concurso' && $regime == '40') {
      $("#aviso-regime").html("Para Concurso Público em regime de 40 horas semanais, deve ser encaminhada aprovação do CONDIR para o regime excepcional junto ao MI.").addClass("alert alert-danger");
    } else {
      $("#aviso-regime").html("").removeClass("alert alert-danger");
    }
  });

  $("#salvar-inicial").click(function(){
    return valida_inicial();
  });

  //-------------------------------------------------------
  //----------------- Prova escrita -----------------------
  //-------------------------------------------------------
  $("#salvar-escrita").click(function(){
    return valida_prova_escrita();
  });

  //--------------------------------------------------------
  //------------------- Prova didática ---------------------
  //--------------------------------------------------------
  // Verifica ao carregar a página também
  ativa_didatica();
  ativa_procedimental();

  // Ao mudar o valor do checkbox, esconde ou mostra as tabelas
  $("#area_prova_didatica").change(function(){
    ativa_didatica();
  });

  $("#area_prova_procedimental").change(function(){
    ativa_procedimental();
  });

  $("#salvar-didatica").click(function(){
    return valida_prova_didatica();
  });

  //-----------------------------------------------------------
  //-------------------- Página titulos -----------------------
  //-----------------------------------------------------------
  // Verificar proporção entre pontuação individual e máxima
  $("input[name*='[maximo]'][name*='[titulos_attributes]']").each(function(){
    erro_proporcao($(this), verifica_proporcao($(this)));
  });

  // No input 'maximo'...
  $(document).on('change', "input[name*='[maximo]'][name*='[titulos_attributes]']", function(){
    erro_proporcao($(this), verifica_proporcao($(this)));
  });

  // e também no input 'valor'.
  $(document).on('change', "input[name*='[valor]'][name*='[titulos_attributes]']", function(){
    erro_proporcao($(this), verifica_proporcao($(this)));
  });

  $("#salvar-titulos").click(function(e){
    return valida_titulos($(this));
  });

  //------------------------------------
  //---------- Botão enviar ------------
  //------------------------------------
  $("#enviar").click(function(){
    if (!valida_inicial()) {
      alert('inicial'); return false;
    } else if (!valida_prova_escrita()) {
      alert('escrita'); return false;
    } else if (!valida_prova_didatica()) {
      alert('didatica'); return false;
    } else if (!valida_titulos()) {
      alert('titulos'); return false;
    } else {
      alert("ok");
    }
  });
});
