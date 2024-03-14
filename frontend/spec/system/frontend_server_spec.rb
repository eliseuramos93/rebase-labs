require 'spec_helper'

RSpec.describe Sinatra::Application, type: :system do
  context 'GET /' do
    it 'Usuário consulta a tabela de exames com sucesso' do
      json_path = File.join(Dir.pwd, 'spec', 'support', 'assets', 'jsons', 'tests_200_list.json')
      json_data = File.read(json_path)

      mock_response = double('Faraday::Response', status: 200, body: json_data)
      allow(Faraday).to receive(:get).with('http://backend:4000/tests').and_return(mock_response)

      visit '/'

      expect(page).to have_content 'Resultados dos Exames'
      expect(page).to have_content 'SCCP10'
      expect(page).to have_content '283.368.670-66'
      expect(page).to have_content 'Reginaldo Rossi'
      expect(page).to have_content 'reidobrega@gmail.com'
      expect(page).to have_content '1944-02-14'
      expect(page).to have_content 'B000BJ20J4'
      expect(page).to have_content 'PI'
      expect(page).to have_content 'Dr. Ross Geller'
    end

    it 'Usuário consulta a tabela de exames mas recebe um alerta de servidor API indisponível' do
      json_path = File.join(Dir.pwd, 'spec', 'support', 'assets', 'jsons', 'api_500.json')
      json_data = File.read(json_path)

      mock_response = double('Faraday::Response', status: 500, body: json_data)
      allow(Faraday).to receive(:get).with('http://backend:4000/tests').and_return(mock_response)

      visit '/'

      expect(page).to have_content 'O servidor está indisponível no momento'
    end

    it 'Usuário pesquisa um exame usando o token e carrega os detalhes do exame com sucesso' do
      result_token_json_path = File.join(Dir.pwd, 'spec', 'support', 'assets', 'jsons', 'result_token_search_200.json')
      result_token_json_data = File.read(result_token_json_path)
      tests_json_path = File.join(Dir.pwd, 'spec', 'support', 'assets', 'jsons', 'tests_200_list.json')
      tests_json_data = File.read(tests_json_path)

      tests_mock_response = double('Faraday::Response', status: 200, body: tests_json_data)
      allow(Faraday).to receive(:get).with('http://backend:4000/tests').and_return(tests_mock_response)
      result_token_mock_response = double('Faraday::Response', status: 200, body: result_token_json_data)
      allow(Faraday).to receive(:get).with('http://backend:4000/tests/SCCP10').and_return(result_token_mock_response)

      visit '/'
      fill_in 'Token do exame', with: 'SCCP10'
      click_button 'Buscar'

      expect(page).to have_current_path '/'

      expect(page).to have_content 'Exame encontrado com sucesso!'
      expect(page).to have_content "Exame:\nSCCP10"
      expect(page).to have_content "Data do resultado (AAAA-MM-DD):\n2023-10-31"
      expect(page).to have_content "CPF:\n283.368.670-66"
      expect(page).to have_content "Nome:\nReginaldo Rossi"
      expect(page).to have_content "E-mail:\nreidobrega@gmail.com"
      expect(page).to have_content "Data de nascimento (AAAA-MM-DD):\n1944-02-14"
      expect(page).to have_content "Médico(a):\nDr. Ross Geller"
      expect(page).to have_content "CRM:\nB000BJ20J4"
      expect(page).to have_content "Estado do CRM:\nPI"
      expect(page).to have_content 'Hemácias'
      expect(page).to have_content 'Limites'
      expect(page).to have_content '45-52'
      expect(page).to have_content 'Resultado'
      expect(page).to have_content '97'
      expect(page).to have_content 'Glóbulos Neutrônicos'
      expect(page).to have_content '2-8'
      expect(page).to have_content '5'
    end

    it 'Usuário pesquisa um exame usando o token mas não executa a busca com o campo de busca vazio' do
      tests_json_path = File.join(Dir.pwd, 'spec', 'support', 'assets', 'jsons', 'tests_200_list.json')
      tests_json_data = File.read(tests_json_path)

      tests_mock_response = double('Faraday::Response', status: 200, body: tests_json_data)
      allow(Faraday).to receive(:get).with('http://backend:4000/tests').and_return(tests_mock_response)

      visit '/'
      fill_in 'Token do exame', with: ''
      click_button 'Buscar'

      expect(page).to have_current_path '/'
      expect(page).to have_content 'É necessário informar o código do exame para realizar a busca.'
      expect(page).not_to have_button 'Voltar para a lista'
      expect(page).not_to have_content 'Exame encontrado com sucesso!'
      expect(page).to have_content 'SCCP10'
      expect(page).to have_content '2023-10-31'
      expect(page).to have_content '283.368.670-66'
      expect(page).to have_content 'Reginaldo Rossi'
      expect(page).to have_content 'reidobrega@gmail.com'
      expect(page).to have_content '1944-02-14'
      expect(page).to have_content 'Dr. Ross Geller'
      expect(page).to have_content 'B000BJ20J4'
      expect(page).to have_content 'PI'
      expect(page).not_to have_content 'Hemácias'
      expect(page).not_to have_content 'Glóbulos Neutrônicos'
      expect(page).not_to have_content 'Limites'
    end

    it 'Usuário pesquisa um exame usando o token e recebe um alerta de erro se nada for encontrado' do
      result_token_json_path = File.join(Dir.pwd, 'spec', 'support', 'assets', 'jsons', 'result_token_not_found.json')
      result_token_json_data = File.read(result_token_json_path)
      tests_json_path = File.join(Dir.pwd, 'spec', 'support', 'assets', 'jsons', 'tests_200_list.json')
      tests_json_data = File.read(tests_json_path)

      tests_mock_response = double('Faraday::Response', status: 200, body: tests_json_data)
      allow(Faraday).to receive(:get).with('http://backend:4000/tests').and_return(tests_mock_response)
      result_token_mock_response = double('Faraday::Response', status: 200, body: result_token_json_data)
      allow(Faraday).to receive(:get).with('http://backend:4000/tests/SCCP10').and_return(result_token_mock_response)

      visit '/'
      fill_in 'Token do exame', with: 'SCCP10'
      click_button 'Buscar'

      expect(page).to have_current_path '/'
      expect(page).to have_content 'Não foi encontrado nenhum exame com o token informado.'
      expect(page).not_to have_content 'Hemácias'
      expect(page).not_to have_content 'Glóbulos Neutrônicos'
    end

    it 'Usuário pesquisa um exame usando o token e recebe um alerta de erro se o BD estiver indisponível' do
      result_token_json_path = File.join(Dir.pwd, 'spec', 'support', 'assets', 'jsons', 'result_token_db_offline.json')
      result_token_json_data = File.read(result_token_json_path)
      tests_json_path = File.join(Dir.pwd, 'spec', 'support', 'assets', 'jsons', 'tests_200_list.json')
      tests_json_data = File.read(tests_json_path)

      tests_mock_response = double('Faraday::Response', status: 200, body: tests_json_data)
      allow(Faraday).to receive(:get).with('http://backend:4000/tests').and_return(tests_mock_response)
      result_token_mock_response = double('Faraday::Response', status: 200, body: result_token_json_data)
      allow(Faraday).to receive(:get).with('http://backend:4000/tests/SCCP10').and_return(result_token_mock_response)

      visit '/'
      fill_in 'Token do exame', with: 'SCCP10'
      click_button 'Buscar'

      expect(page).to have_current_path '/'
      expect(page).to have_content 'Não foi possível conectar-se ao banco de dados.'
      expect(page).not_to have_content 'Hemácias'
      expect(page).not_to have_content 'Glóbulos Neutrônicos'
    end

    it 'Usuário pesquisa um exame usando o token mas recebe um alerta de servidor API indisponível' do
      tests_json_path = File.join(Dir.pwd, 'spec', 'support', 'assets', 'jsons', 'tests_200_list.json')
      tests_json_data = File.read(tests_json_path)
      result_token_json_path = File.join(Dir.pwd, 'spec', 'support', 'assets', 'jsons', 'api_500.json')
      result_token_json_data = File.read(result_token_json_path)

      result_token_mock_response = double('Faraday::Response', status: 500, body: result_token_json_data)
      tests_mock_response = double('Faraday::Response', status: 200, body: tests_json_data)
      allow(Faraday).to receive(:get).with('http://backend:4000/tests').and_return(tests_mock_response)
      allow(Faraday).to receive(:get).with('http://backend:4000/tests/SCCP10').and_return(result_token_mock_response)

      visit '/'
      fill_in 'Token do exame', with: 'SCCP10'
      click_button 'Buscar'

      expect(page).to have_content 'O servidor está indisponível no momento'
    end

    it 'Usuário retorna para a lista de exames caso ao clicar no botão "Voltar para a lista"' do
      result_token_json_path = File.join(Dir.pwd, 'spec', 'support', 'assets', 'jsons', 'result_token_search_200.json')
      result_token_json_data = File.read(result_token_json_path)
      tests_json_path = File.join(Dir.pwd, 'spec', 'support', 'assets', 'jsons', 'tests_200_list.json')
      tests_json_data = File.read(tests_json_path)

      tests_mock_response = double('Faraday::Response', status: 200, body: tests_json_data)
      allow(Faraday).to receive(:get).with('http://backend:4000/tests').and_return(tests_mock_response)
      result_token_mock_response = double('Faraday::Response', status: 200, body: result_token_json_data)
      allow(Faraday).to receive(:get).with('http://backend:4000/tests/SCCP10').and_return(result_token_mock_response)

      visit '/'
      fill_in 'Token do exame', with: 'SCCP10'
      click_on 'Buscar'
      click_on 'Voltar para a lista'

      expect(page).to have_current_path '/'
      expect(page).not_to have_button 'Voltar para a lista'
      expect(page).not_to have_content 'Exame encontrado com sucesso!'
      expect(page).to have_content 'SCCP10'
      expect(page).to have_content '2023-10-31'
      expect(page).to have_content '283.368.670-66'
      expect(page).to have_content 'Reginaldo Rossi'
      expect(page).to have_content 'reidobrega@gmail.com'
      expect(page).to have_content '1944-02-14'
      expect(page).to have_content 'Dr. Ross Geller'
      expect(page).to have_content 'B000BJ20J4'
      expect(page).to have_content 'PI'
      expect(page).not_to have_content 'Hemácias'
      expect(page).not_to have_content 'Glóbulos Neutrônicos'
      expect(page).not_to have_content 'Limites'
    end

    it 'Usuário solicita a importação assíncrona dos dados de exames ao clicar no botão "Importar Dados"' do
      json_path = File.join(Dir.pwd, 'spec', 'support', 'assets', 'jsons', 'import_200.json')
      json_data = File.read(json_path)
      mock_tests_response = double('Faraday::Response', status: 200, body: '[]')
      mock_import_response = double('Faraday::Response', status: 200, body: json_data)
      allow(Faraday).to receive(:get).with('http://backend:4000/tests').and_return(mock_tests_response)
      allow(Faraday).to receive(:post).and_return(mock_import_response)

      visit '/'
      file_path = File.join(Dir.pwd, 'spec', 'support', 'assets', 'csvs', 'test_data.csv')
      attach_file 'Importar arquivo', file_path
      click_on 'Importar Dados'

      expect(page).to have_current_path '/'
      expect(page).to have_content 'Importação de dados solicitada com sucesso! Em breve seus dados estarão disponíveis'
    end

    it 'Usuário solicita a importação assíncrona dos dados de exames mas recebe erro de API indisponível' do
      tests_json_path = File.join(Dir.pwd, 'spec', 'support', 'assets', 'jsons', 'tests_200_list.json')
      tests_json_data = File.read(tests_json_path)
      import_json_path = File.join(Dir.pwd, 'spec', 'support', 'assets', 'jsons', 'api_500.json')
      import_json_data = File.read(import_json_path)

      import_mock_response = double('Faraday::Response', status: 500, body: import_json_data)
      tests_mock_response = double('Faraday::Response', status: 200, body: tests_json_data)
      allow(Faraday).to receive(:get).with('http://backend:4000/tests').and_return(tests_mock_response)
      allow(Faraday).to receive(:post).and_return(import_mock_response)

      visit '/'
      file_path = File.join(Dir.pwd, 'spec', 'support', 'assets', 'csvs', 'test_data.csv')
      attach_file 'Importar arquivo', file_path
      click_on 'Importar Dados'

      expect(page).to have_content 'O servidor está indisponível no momento'
    end
  end
end
