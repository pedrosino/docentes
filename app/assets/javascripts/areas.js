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
  } else {
    $(".panel.procedimental").hide();
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

onPage('areas edit, areas update', function() {
  $(function(){
    var qual = $("#area_qualif_prorrogar").parent("div");
    qual.hide();
    $("#salvar").hide();

    ativa_didatica();
    ativa_procedimental();

    $("#area_prorrogar").change(function(){
      if($(this).is(":checked")) {
        qual.show();
        qual.prop("disabled", "");
      } else {
        qual.hide();
      }
    });

    // O formulário é dividido em fases. Primeiro as informações básicas, depois a prova escrita,
    // depois a prova didática, depois a análise de títulos. Em cada fase é feita uma validação
    // do que foi preenchido. O formulário só avança se estiver tudo certo.
    $("#avancar").click(function(){
      // Primeiro clique -> após preencher informações iniciais.
      // Verificar se todos os necessários foram preenchidos.
      // (usar required)
      if(window.fase == 1) {
        $(".bloco-inicial").hide();
        $(".prova-escrita").show();
        window.fase = 2;
      // Segundo clique -> após preencher critérios da prova escrita.
      // Verificar se os critérios somam 100 pontos.
      } else if(window.fase == 2) {
        if (verifica_soma($(".criterios-escrita"),"valor", 100)) {
          $(".prova-escrita").hide();
          $(".prova-didatica").show();
          window.fase = 3;
          $(".panel.panel-default.escrita>.panel-body>.mensagem-erro").removeClass('alert alert-danger').html("");
        } else {
          $(".panel.panel-default.escrita>.panel-body>.mensagem-erro").addClass('alert alert-danger').
          html("A soma dos critérios não atinge 100 pontos!");
        }
      // Terceiro clique -> após preencher a prova didática.
      // Em concurso público a prova didática é obrigatória.
      // Pode haver também prova didática procedimental, tanto nos concursos quanto nos processos seletivos.
      // Caso a prova esteja marcada, os critérios devem somar 100 pontos.
      } else if(window.fase == 3) {
        var validado_didatica = true;
        if ($("#area_prova_didatica").is(":checked")) {
          if (!verifica_soma($(".criterios-didatica"),"valor", 100)) {
            validado_didatica = false;
          }
        }

        var validado_procedimental = true;
        if ($("#area_prova_procedimental").is(":checked")) {
          if (!verifica_soma($(".criterios-procedimental"),"valor", 100)) {
            validado_procedimental = false;
          }
        }

        if (validado_didatica) {
          if (validado_procedimental) {
            $(".prova-didatica").hide();
            $(".titulos").show();
            $("#salvar").show();
            $("#avancar").hide();
            window.fase = 4;
          }
        } else {
          if (!validado_procedimental) {
            $(".panel.panel-default.procedimental>.panel-body>.mensagem-erro").addClass('alert alert-danger').html("A soma dos critérios não atinge 100 pontos!");
          }
          if (!validado_didatica) {
          $(".panel.panel-default.didatica>.panel-body>.mensagem-erro").addClass('alert alert-danger').html("A soma dos critérios não atinge 100 pontos!");
          }
        }
      }
    });

    $("#area_prova_didatica").change(function(){
      ativa_didatica();
    });

    $("#area_prova_procedimental").change(function(){
      ativa_procedimental();
    });
  });
});
