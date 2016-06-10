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

function verifica_soma($objeto, $tipo, $total) {
  var soma = 0;
  var find_input = "input[name*='" + $tipo + "']";
  $($objeto).find(find_input).each(function() {
    soma += parseFloat($(this).val());
  });
  return (soma == $total);
}

/////////////////////////////////////////////////
//////    Informações básicas da área     ///////
/////////////////////////////////////////////////
onPage('areas inicial, areas edit, areas update', function(){
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
});

// Prova escrita
onPage('areas escrita, areas edit, areas update', function(){
  $("#salvar-escrita").click(function(){
    if (verifica_soma($(".criterios-escrita"),"valor", 100)) {
      $(".panel.panel-default.escrita>.panel-body>.mensagem-erro").removeClass('alert alert-danger').html("");
    } else {
      $(".panel.panel-default.escrita>.panel-body>.mensagem-erro").addClass('alert alert-danger').
      html("A soma dos critérios não atinge 100 pontos!");
      return false;
    }
  });
});

// Prova didática
onPage('areas didatica, areas edit, areas update', function(){
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
    // Verifica a prova didática (pedagógica)
    var validado_didatica = true;
    if ($("#area_prova_didatica").is(":checked")) {
      if (!verifica_soma($(".criterios-didatica"),"valor", 100)) {
        validado_didatica = false;
      }
      if (!validado_didatica) {
        $(".panel.panel-default.didatica>.panel-body>.mensagem-erro").addClass('alert alert-danger').html("A soma dos critérios não atinge 100 pontos!");
      }
    }

    // Verifica a prova procedimental
    var validado_procedimental = true;
    var duracao = true;
    if ($("#area_prova_procedimental").is(":checked")) {
      if (!verifica_soma($(".criterios-procedimental"),"valor", 100)) {
        validado_procedimental = false;
      }

      if (!validado_procedimental) {
        $(".panel.panel-default.procedimental>.panel-body>.mensagem-erro").addClass('alert alert-danger').html("A soma dos critérios não atinge 100 pontos!");
      }

      // Verifica se a duração foi preenchida
      $(".numeric.integer.optional.form-control").each(function(){
        if ($(this).val() == "") {
          $(this).parent().addClass("alert alert-danger");
          duracao = false;
        }
      });
    }

    // Impede o formulário de ser enviado
    if (!validado_didatica || !validado_procedimental || !duracao) {
      return false;
    }
  });
});

//////////////////////////////////////////////////////
///////////////   Página /titulos ////////////////////
//////////////////////////////////////////////////////
function verifica_proporcao($objeto) {
  var numero = ($objeto.prop('id').split('_'))[3];
  $maximo = $("input[name*='[titulos_attributes]["+numero+"][maximo]'").val();
  $individual = $("input[name*='[titulos_attributes]["+numero+"][valor]'").val();
  $correto = (($maximo % $individual) == 0);
  return $correto;
}

function erro_proporcao($objeto, $correto) {
  var numero = ($objeto.prop('id').split('_'))[3];
  $input_maximo = $("input[name*='[titulos_attributes]["+numero+"][maximo]'");
  if ($correto) {
    $input_maximo.siblings('p').html("");
    $input_maximo.closest('td').removeClass('alert alert-danger');
  } else {
    $input_maximo.siblings('p').html("A proporção entre a pontuação máxima e a pontuação individual não está correta!");
    $input_maximo.closest('td').addClass('alert alert-danger');
  }
}

onPage('areas titulos, areas edit, areas update', function(){
  // Verificar proporção entre pontuação individual e máxima
  $("input[name*='[maximo]']").each(function(){
    erro_proporcao($(this), verifica_proporcao($(this)));
  });

  // No input 'maximo'...
  $(document).on('change', "input[name*='[maximo]']", function(){
    erro_proporcao($(this), verifica_proporcao($(this)));
  });

  // e também no input 'valor'.
  $(document).on('change', "input[name*='[valor]']", function(){
    erro_proporcao($(this), verifica_proporcao($(this)));
  });

  $("#salvar-titulos").click(function(e){
    // Verificar soma de cada parte
    var validado_atividades = true;
    if (!verifica_soma($(".table.atividades"),"maximo", $("input[name='maximo-atividades']").val())) {
      validado_atividades = false;
    }

    var validado_producao = true;
    if (!verifica_soma($(".table.producao"),"maximo", $("input[name='maximo-producao']").val())) {
      validado_producao = false;
    }

    if (!validado_atividades) {
      $(".panel.panel-default.atividades>.panel-body>.mensagem-erro").addClass('alert alert-danger').html("A soma dos itens não atinge a pontuação máxima!");
      e.preventDefault();
    }
    if (!validado_producao) {
      $(".panel.panel-default.producao>.panel-body>.mensagem-erro").addClass('alert alert-danger').html("A soma dos itens não atinge a pontuação máxima!");
      e.preventDefault();
    }

    // Verifica proporções
    var validado_proporcao = true;
    $("input[name*='[maximo]']").each(function(){
      if (!verifica_proporcao($(this))) {
        validado_proporcao = false;
        alert($(this).prop('id'));
      }
    });
    if (!validado_proporcao) {
      e.preventDefault();
    }
  });
});
