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

function verifica_soma($objeto, $tipo) {
  //var soma = 0;
  var find_input = "input[name*='" + $tipo + "']";
  $($objeto).find(find_input).each(function() {
    alert($(this).val());
  });
  //alert(soma);
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

    $("#avancar").click(function(){
      switch(window.fase) {
        case 1: $(".bloco-inicial").hide(); $(".prova-escrita").show(); window.fase = 2; break;
        case 2: $(".prova-escrita").hide(); verifica_soma($(".criterios-didatica"),"valor"); $(".prova-didatica").show(); window.fase = 3; break;
        case 3: $(".prova-didatica").hide(); $(".titulos").show(); $("#salvar").show(); $("#avancar").hide(); window.fase = 4; break;
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
