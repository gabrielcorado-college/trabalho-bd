Pakyow::App.routes do
  default do
    logger.info 'hello'
  end

  #
  # SQL Utilizado nas filiais:
  # SELECT * FROM filiais
  # SELECT * FROM filiais WHERE filial_id = 1 LIMIT 1
  # INSERT INTO filiais (endereco, nome_gerente) VALUES ('', '')
  # UPDATE filiais SET (endereco, nome_gerente) = ('', '') WHERE filial_id = 1
  # DELETE FROM filiais WHERE filial_id = 1
  #
  restful :filial, '/filiais' do
    list do
      # Select the rows
      # SELECT * FROM filiais
      dataset = $db["SELECT * FROM filiais"]
      data = []

      # Each the rows of the table
      dataset.each do |row|
        data << row
      end

      # Pass the data to the view
      view.scope(:filiais).apply(data) do |ctx, post_data|
        # The resource possible routes
        routes = {
          remove: router.group(:filial).path(:remove, filial_id: post_data[:filial_id]),
          edit: router.group(:filial).path(:edit, filial_id: post_data[:filial_id])
        }

        # Set the routes to the properties
        ctx.prop(:remove).attrs['href'] = routes[:remove]
        ctx.prop(:edit).attrs['href'] = routes[:edit]
      end
    end

    new do
      view.scope(:filial).bind({ action: 'Adicionar' })
    end

    edit do
      # Seleciona um registro para editar
      # SELECT * FROM filiais WHERE filial_id = 1 LIMIT 1
      dataset = $db["SELECT * FROM filiais WHERE filial_id = #{params[:filial_id]} LIMIT 1"]

      data = {
        action: 'Editar'
      }

      dataset.each do |row|
        data.merge!(row)
      end

      view.scope(:filial).bind(data)
    end

    create do
      filial = params[:filial]

      if filial[:filial_id] == ''
        # Novo registro
        # INSERT INTO filiais (endereco, nome_gerente) VALUES ('', '')
        $db.run("INSERT INTO filiais (endereco, nome_gerente) VALUES (\'#{filial['endereco']}\', \'#{filial['nome_gerente']}\')")
      else
        # Atualizar registro
        # UPDATE filiais SET (endereco, nome_gerente) = ('', '') WHERE filial_id = 1
        $db.run("UPDATE filiais SET (endereco, nome_gerente) = (\'#{filial['endereco']}\', \'#{filial['nome_gerente']}\') WHERE filial_id = #{filial['filial_id']}")
      end

      redirect '/filiais'
    end

    get :remove, ':filial_id/delete' do
      # Delete um registro com a chave primaria
      # DELETE FROM filiais WHERE filial_id = 1
      $db.run("DELETE FROM filiais WHERE filial_id = #{params[:filial_id]}")
      redirect '/filiais'
    end
  end
end
