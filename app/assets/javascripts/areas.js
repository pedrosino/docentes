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

function mostra_qualificacao($qual) {
  var nome = ($qual.prop('id').split('_'))[1];
  $text_area = $("#area_descricao_" + nome);
  if ($qual.is(":checked")) {
    $text_area.parent("div").show();
  } else {
    $text_area.parent("div").hide();
  }
}

function monta_qualificacao() {
  var completa = "";
  $(".qualificacao").find('input.boolean').each(function() {
    if ($(this).is(":checked")) {
      var nome = ($(this).prop('id').split('_'))[1];
      completa += ($(this).parent("label").html().split('>'))[1] + " em " + $("#area_descricao_" + nome).val() + " com\n";
    }
  });

  $("#area_qualif_prorrogar").val($.trim(completa.substr(0, completa.length-5)));
}

function mostra_prorrogacao() {
  if($("#area_prorrogar").is(":checked")) {
    $("div.radio_buttons.area_mantem_qualificacao").show();
    if ($("#area_mantem_qualificacao_false").is(":checked")) {
      $("#area_qualif_prorrogar").parent("div").show();
    } else {
      $("#area_qualif_prorrogar").parent("div").hide();
    }
  } else {
    $("div.radio_buttons.area_mantem_qualificacao").hide();
    $("#area_qualif_prorrogar").parent("div").hide();
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
      // troca virgula por ponto, se houver
      soma += parseFloat($(this).val().replace(',','.'));
      contar += 1;
    }
  });
  if (contar < 2) {
    return -1;
  }
  return (soma == $total);
}

function modulo_especial(big, small) {
  return ((big * 100) % (small * 100)) / 100;
}

function verifica_proporcao($objeto) {
  var numero = ($objeto.prop('id').split('_'))[3];
  // troca virgula por ponto, se houver
  $maximo = parseFloat($("input[name*='[titulos_attributes]["+numero+"][maximo]']").val().replace(',','.'));
  $individual = parseFloat($("input[name*='[titulos_attributes]["+numero+"][valor]']").val().replace(',','.'));
  $correto = (modulo_especial($maximo, $individual) == 0);
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

function rolar_para($objeto, $tempo=500) {
  $('html, body').animate({
    scrollTop: $objeto.offset().top
  }, $tempo);
}

// Funções de validação de cada parte
// Retornam false se a validação falhar
function valida_inicial() {
  var preenchidos = true;
  $("#inicial").find(":input.required").each(function(){
    if ($(this).val() == "") {
      preenchidos = false;
    }
  });
  return preenchidos;
}

function valida_prova_escrita() {
  var confere = verifica_soma($(".criterios-escrita"),"valor", 100,"criterios");
  if (confere == -1) {
    $(".panel.panel-default.escrita>.panel-body>.mensagem-erro").addClass('alert alert-danger').
    html("Preencha pelo menos dois critérios!");
    rolar_para($(".panel.panel-default.escrita>.panel-body>.mensagem-erro"));
    return false;
  } else if (!confere) {
    $(".panel.panel-default.escrita>.panel-body>.mensagem-erro").addClass('alert alert-danger').
    html("A soma dos critérios não é igual a 100 pontos!");
    rolar_para($(".panel.panel-default.escrita>.panel-body>.mensagem-erro"));
    return false;
  } else {
    $(".panel.panel-default.escrita>.panel-body>.mensagem-erro").removeClass('alert alert-danger').html("");
  }

  var preenchidos = true;
  $("#escrita").find(":input.required").each(function() {
    if($(this).val() == "") {
      $(this).addClass("alert-danger");
      preenchidos = false;
    } else {
      $(this).removeClass("alert-danger");
    }
  });

  if (!preenchidos) {
    return false;
  }
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
      rolar_para($(".panel.panel-default.didatica>.panel-body>.mensagem-erro"));
    } else if (!confere) {
      $(".panel.panel-default.didatica>.panel-body>.mensagem-erro").addClass('alert alert-danger').html("A soma dos critérios não é igual a 100 pontos!");
      validado_didatica = false;
      rolar_para($(".panel.panel-default.didatica>.panel-body>.mensagem-erro"));
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
    var confere = verifica_soma($(".criterios-procedimental"),"valor", 100, "criterios");
    if (confere == -1) {
      $(".panel.panel-default.procedimental>.panel-body>.mensagem-erro").addClass('alert alert-danger').html("Preencha pelo menos dois critérios!");
      validado_procedimental = false;
      rolar_para($(".panel.panel-default.procedimental>.panel-body>.mensagem-erro"));
    } else if (!confere) {
      $(".panel.panel-default.procedimental>.panel-body>.mensagem-erro").addClass('alert alert-danger').html("A soma dos critérios não é igual a 100 pontos!");
      validado_procedimental = false;
      rolar_para($(".panel.panel-default.procedimental>.panel-body>.mensagem-erro"));
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

    $min_proced = $("#area_min_procedimental");
    if (!/minuto/i.test($min_proced.val()) && !/hora/i.test($min_proced.val())) {
      $min_proced.addClass('alert-danger');
    } else {
      $min_proced.removeClass('alert-danger');
    }

    $max_proced = $("#area_max_procedimental");
    if (!/minuto/i.test($max_proced.val()) && !/hora/i.test($max_proced.val())) {
      $max_proced.addClass('alert-danger');
    } else {
      $max_proced.removeClass('alert-danger');
    }
  }

  // Impede o formulário de ser enviado
  if (!validado_didatica || !validado_procedimental || !duracao || !preenchidos) {
    return false;
  }
  return true;
}

function valida_titulos() {
  // Verificar soma de cada parte
  var validado_atividades = true;
  var confere_atividades = verifica_soma($(".table.atividades"),"maximo", $("input[name='maximo-atividades']").val(), "titulos");
  if (confere_atividades == -1) {
    $(".panel.panel-default.atividades>.panel-body>.mensagem-erro").addClass('alert alert-danger').html("Preencha pelo menos dois itens!");
    validado_atividades = false;
    rolar_para($(".panel.panel-default.atividades>.panel-body>.mensagem-erro"));
  } else if (!confere_atividades) {
    $(".panel.panel-default.atividades>.panel-body>.mensagem-erro").addClass('alert alert-danger').html("A soma dos itens não é igual a pontuação máxima!");
    validado_atividades = false;
    rolar_para($(".panel.panel-default.atividades>.panel-body>.mensagem-erro"));
  } else {
    $(".panel.panel-default.atividades>.panel-body>.mensagem-erro").removeClass('alert alert-danger').html("");
  }

  var validado_producao = true;
  var confere_producao = verifica_soma($(".table.producao"),"maximo", $("input[name='maximo-producao']").val(), "titulos");
  if (confere_producao == -1) {
    $(".panel.panel-default.producao>.panel-body>.mensagem-erro").addClass('alert alert-danger').html("Preencha pelo menos dois itens!");
    validado_producao = false;
    rolar_para($(".panel.panel-default.producao>.panel-body>.mensagem-erro"));
  } else if (!confere_producao) {
    $(".panel.panel-default.producao>.panel-body>.mensagem-erro").addClass('alert alert-danger').html("A soma dos itens não é igual a pontuação máxima!");
    validado_producao = false;
    rolar_para($(".panel.panel-default.producao>.panel-body>.mensagem-erro"));
  } else {
    $(".panel.panel-default.producao>.panel-body>.mensagem-erro").removeClass('alert alert-danger').html("");
  }

  // Se tiver prorrogação alterando a qualificação (e for concurso público),
  // tem uma segunda tabela da produção científica e/ou artística, com máximo de 70 pontos.
  if ($(".table.producao-prorrogacao").length) {
    var validado_producao_pro = true;
    var confere_producao_pro = verifica_soma($(".table.producao-prorrogacao"),"maximo", 70, "titulos");
    if (confere_producao_pro == -1) {
      $(".panel.panel-default.producao-prorrogacao>.panel-body>.mensagem-erro").addClass('alert alert-danger').html("Preencha pelo menos dois itens!");
      validado_producao_pro = false;
      rolar_para($(".panel.panel-default.producao-prorrogacao>.panel-body>.mensagem-erro"));
    } else if (!confere_producao_pro) {
      $(".panel.panel-default.producao-prorrogacao>.panel-body>.mensagem-erro").addClass('alert alert-danger').html("A soma dos itens não é igual a pontuação máxima!");
      validado_producao_pro = false;
      rolar_para($(".panel.panel-default.producao-prorrogacao>.panel-body>.mensagem-erro"));
    } else {
      $(".panel.panel-default.producao-prorrogacao>.panel-body>.mensagem-erro").removeClass('alert alert-danger').html("");
    }
  } else {
    var validado_producao_pro = true;
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

  if (!validado_atividades || !validado_producao || !validado_producao_pro || !validado_proporcao || !coautoria || !preenchidos) {
    return false;
  }
  return true;
}

// Todas as validações juntas
function valida_todas() {
  return (valida_inicial() && valida_prova_escrita() && valida_prova_didatica() && valida_titulos());
}

onPage('areas edit, areas update', function(){
  // Se o usuário pressionar Enter, o formulário não é enviado
  $(window).keydown(function(event){
    if(event.keyCode == 13) {
      event.preventDefault();
      return false;
    }
  });

  // Desabilita botão enviar, inicialmente
  $("#enviar").hide();
  // Se estiver tudo ok, habilita o botão
  if (valida_todas()) {
    $("#enviar").show();
    $(".mensagem-ok").html("Não existem mais pendências! Você pode enviar esta solicitação no botão no final da página.");
    $(".mensagem-ok").show();
  } else {
    $(".mensagem-ok").hide();
  }

  //---------------------------------------------------------
  //------------- Informações básicas da área ---------------
  //---------------------------------------------------------
  // Esconde caixas da qualificação
  $(".qualificacao").find('textarea').each(function() {
    $(this).parent("div").hide();
  });

  // Percorre checkboxes e mostra textarea se necessário
  $(".qualificacao").find('input.boolean').each(function() {
    mostra_qualificacao($(this));
  });

  $(".qualificacao").find('input.boolean').change(function() {
    mostra_qualificacao($(this));
    monta_qualificacao();
  });

  $("textarea[name*='area[descricao']").change(function() {
    monta_qualificacao();
  })

  // Mostra caixa da prorrogação
  mostra_prorrogacao();

  $("#area_prorrogar").change(function() {
    mostra_prorrogacao();
  });

  $(".area_mantem_qualificacao").click(function() {
    mostra_prorrogacao();
  });

  $("#area_regime").on('change', function() {
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

  $("#salvar-titulos").click(function(){
    return valida_titulos();
  });

  //------------------------------------
  //---------- Botão enviar ------------
  //------------------------------------
  $("#enviar").click(function(){
    if (!valida_inicial()) {
      alert('Pendências nas informações iniciais');
      return false;
    } else if (!valida_prova_escrita()) {
      alert('Pendências na prova escrita');
      return false;
    } else if (!valida_prova_didatica()) {
      alert('Pendências na prova didática');
      return false;
    } else if (!valida_titulos()) {
      alert('Pendências na análise de títulos');
      return false;
    }

    // Impede o envio caso haja alterações que não foram salvas
    return nao_salvou();
  });

  $("#voltar").click(function(e){
    if (nao_salvas) {
      return window.confirm("Você perderá qualquer alteração que não foi salva. Continuar?");
    }
  });

  // http://stackoverflow.com/a/3752331/5656749
  $("#clonar").click(function() {
    $("table.titulos.producao > tbody > tr").each(function() {
      $clone = $(this).clone(true);
      $clone.find(':input').each(function() {
        // Muda id e name
        $numero = ($(this).prop('id').split('_'))[3];
        $(this).prop('id', $(this).prop('id').replace($numero, $numero+123));
        $(this).prop('name', $(this).prop('name').replace($numero, $numero+123));
        // Altera valor conforme necessário
        if ($(this).is("input") && $(this).attr('type') == 'text') {
          // Multiplica por 0.875
          $valor_antigo = parseFloat($(this).val().replace(',', '.'));
          $(this).val($valor_antigo * 0.875);
        }
        if ($(this).is("input") && $(this).prop('name').indexOf('prorrogacao') >= 0) {
          // Muda para true
          $(this).val('true');
        }
      });
      $clone.appendTo("table.titulos.producao-prorrogacao > tbody");
    });
    //return false;
  });

  //------- Verifica alterações não salvas ----------
  // Ao carregar a página, a variável é falsa
  var nao_salvas = false;

  // A qualquer mudança em algum campo, a variável se torna verdadeira
  $(document).on('change',':input', function(){ //trigers change in all input fields including text type
    nao_salvas = true;
  });

  function nao_salvou() {
    if (nao_salvas) {
      alert("Você fez alterações que ainda não foram salvas! Clique no botão Salvar antes de enviar.");
      return false;
    }
    return true;
  }
});
