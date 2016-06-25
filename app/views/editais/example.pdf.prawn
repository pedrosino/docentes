require "prawn/measurement_extensions"

prawn_document(page_size: "A4",
               left_margin: 3.cm,
               right_margin: 1.cm,
               top_margin: 0.5.cm,
               bottom_margin: 0.5.cm ) do |pdf|

  # Fonte
  pdf.font "Times-Roman"
  pdf.bounding_box([pdf.bounds.left, pdf.bounds.top - 100], width: pdf.bounds.width, height: pdf.bounds.height - 110) do
    pdf.bounding_box([pdf.bounds.left + 7.cm, pdf.bounds.top], width: pdf.bounds.width - 7.cm) do
      pdf.text "CONCURSO PÚBLICO DE PROVAS E TÍTULOS PARA PREENCHIMENTO DE VAGA(S) DE PROFESSOR DA CARREIRA DE MAGISTÉRIO SUPERIOR " +
      "INTEGRANTE DO PLANO DE CARREIRAS E CARGOS DE MAGISTÉRIO FEDERAL.", size: 3.88.mm, style: :bold, align: :justify
    end

    pdf.move_down 0.5.cm

    pdf.text "A Pró - Reitora de Gestão de Pessoas da Universidade Federal de Uberlândia, no uso de suas atribuições e considerando " +
    "a delegação de competência que lhe foi outorgada por meio da Portaria/R/UFU/nº. 1.224, de 29/12/2015, do Reitor da Universidade " +
    "Federal  de Uberlândia, publicada no Diário Oficial da União em 11/01/2016; e tendo em vista o que estabelecem a Lei nº. 8.112, " +
    "de 11/12/1990, a Lei 12.772 de 28/12/2012, a Lei 12.863 publicada no D.O.U. em 25/09/2013, bem como o Decreto 6.944 de 21/08/2009 " +
    "publicado no D.O.U em 24/08/2009, o Decreto nº. 7.485 de 18/05/2011; alterado pelo Decreto nº. 8.259 de 29/05/2014 e a Portaria " +
    "Interministerial MPOG/MEC nº. 111, de 03/04/2014; e também o Estatuto e o Regimento Geral da UFU, a Resolução nº 03/2015 do " +
    "Conselho Diretor e demais legislações pertinentes, torna público que será realizado Concurso Público de Provas e Títulos, para " +
    "o cargo de Professor da Carreira de Magistério Superior do Plano de Carreiras e Cargos de Magistério Federal da Universidade " +
    "Federal de Uberlândia, mediante as normas contidas neste Edital.", align: :justify

    50.times do
      pdf.text Faker::Lorem.paragraph(6), align: :justify
    end
  end

  pdf.repeat :all do
    # header
    pdf.bounding_box [pdf.bounds.left, pdf.bounds.top], width: pdf.bounds.width do
      my_table = pdf.make_table([["SERVIÇO PÚBLICO FEDERAL"],
                               ["MINISTÉRIO DA EDUCAÇÃO"],
                               ["UNIVERSIDADE FEDERAL DE UBERLÂNDIA"],
                               ["PRÓ-REITORIA DE GESTÃO DE PESSOAS"]], cell_style: { align: :center, borders: [], font_style: :bold, size: 3.88.mm, padding: [0,0,0,0] })

      pdf.table([["imagem 1", my_table, "imagem 2"]], width: pdf.bounds.width, cell_style: { align: :center, borders: []})
      pdf.move_down 8
      pdf.stroke_horizontal_rule
      pdf.move_down 8
      pdf.text "EDITAL nº #{@edital.numero}", align: :center, size: 5.mm
      pdf.move_down 4
      pdf.stroke_horizontal_rule
    end
  end

  string = "Página <page> de <total>"
    # Green page numbers 1 to 11
  options = { :at => [pdf.bounds.right - 150, 10],
    :width => 150,
    :align => :right,
    :page_filter => (1..11),
    :start_count_at => 1 }
  pdf.number_pages string, options
end
