const alerts = document.getElementById('alerts');
// Criar tabela listando todos os exames
fetch('/tests')
  .then((response) => response.json())
  .then((data) => {
    const table = document.getElementById('list-exams-tbody')
    const pagination = document.getElementById('pagination');
    const itemsPerPage = 30;
    let currentPage = 0;

    function addValueToTable(value, tableRow) {
      const dataCell = document.createElement('td');

      dataCell.textContent = `${value}`;
      dataCell.classList.add('table-cell');
      tableRow.appendChild(dataCell);
    }

    function displayData(data, page) {
      table.innerHTML = '';
      const startIndex = page * itemsPerPage;
      const endIndex = startIndex + itemsPerPage;
      const pageData = data.slice(startIndex, endIndex);

      pageData.forEach(test => {
        const tableRow = document.createElement('tr');
        Object.values(test).forEach(value => {
          if (typeof value != 'object') {
            addValueToTable(value, tableRow);
          } else if ('crm' in value) {
            Object.values(value).forEach((doctorValue) => {
              addValueToTable(doctorValue, tableRow);
            })
          }
        })
        table.appendChild(tableRow);
      });
    };

    function setupPagination(data) {
      const pageCount = Math.ceil(data.length / itemsPerPage);

      for (let index = 0; index < pageCount; index++) {
        const button = document.createElement('button');
        button.textContent = index + 1;
        button.classList.add('btn')
        button.addEventListener('click', () => {
          currentPage = index;
          displayData(data, currentPage);
          window.scrollTo(0, 0);
        });
        pagination.appendChild(button);
      }
    };

    displayData(data, currentPage);
    setupPagination(data);
  });

// Pesquisando por um exame específico usando o formulário

const listExamsSection = document.getElementById('list-exams-section');
const searchExamResultsSection = document.getElementById('search-exam-results-section');
const searchExamButton = document.getElementById('search-exam-button');
const resultToken = document.getElementById('result-token');
const searchExamInfoDiv = document.getElementById('search-exam-info');
const searchExamResustsTableDiv = document.getElementById('search-exam-test-results');

searchExamButton.addEventListener('click', (event) => {
  event.preventDefault();

  if (resultToken.value == '') {
    alerts.classList = 'alert warning';
    alerts.innerHTML = 'É necessário informar o código do exame para realizar a busca.'
    return;
  } 

  searchExamResustsTableDiv.innerHTML = '';
  searchExamInfoDiv.innerHTML = '';

  function createListTitleValuePair(list, title, value) {
    const titleElement = document.createElement('dt');
    const valueElement = document.createElement('dd');
    titleElement.textContent = title;
    valueElement.textContent = value;
    list.appendChild(titleElement);
    list.appendChild(valueElement);
  };

  function createTestResultsRow(tbody, test) {
    const testRow = document.createElement('tr');
    
    Object.values(test).forEach((value) => {
      const testCell = document.createElement('td');
      testCell.textContent = value;
      testCell.classList.add('table-cell');
      testCell.classList.add('search-result-cell');
      testRow.appendChild(testCell);
    });

    tbody.appendChild(testRow);
  };

  function createTestsResultTable(tests) {
    const table = document.createElement('table');
    const thead = document.createElement('thead');
    const tbody = document.createElement('tbody');
    const headerRow = document.createElement('tr');
    const headers = ['Teste', 'Limites', 'Resultado'];

    headers.forEach((header) => {
      const headerCell = document.createElement('th');
      headerCell.textContent = header;
      headerCell.classList.add('table-cell');
      headerRow.appendChild(headerCell);
    });

    tests.forEach((test) => {
      createTestResultsRow(tbody, test);
    });

    thead.appendChild(headerRow);
    table.appendChild(thead);
    table.appendChild(tbody);
    searchExamResustsTableDiv.appendChild(table);
  }

  fetch(`/tests/${resultToken.value}`).
    then((response) => response.json()).
    then((data) => {
      if ('errors' in data) {
        alerts.classList = 'alert error';
        alerts.innerHTML = data.errors.message;
        return;
      }
      if (searchExamResultsSection.classList.contains('hidden')) {
        listExamsSection.classList.toggle('hidden');
        searchExamResultsSection.classList.toggle('hidden');
      };
      
      const foundExamList = document.createElement('dl');
      
      createListTitleValuePair(foundExamList, 'Exame:', data.result_token);
      createListTitleValuePair(foundExamList, 'Data do resultado (AAAA-MM-DD):', data.date);
      createListTitleValuePair(foundExamList, 'Nome:', data.full_name);
      createListTitleValuePair(foundExamList, 'CPF:', data.cpf);
      createListTitleValuePair(foundExamList, 'E-mail:', data.email);
      createListTitleValuePair(foundExamList, 'Data de nascimento (AAAA-MM-DD):', data.birth_date);
      createListTitleValuePair(foundExamList, 'Médico(a):', data.doctor.full_name);
      createListTitleValuePair(foundExamList, 'CRM:', data.doctor.crm);
      createListTitleValuePair(foundExamList, 'Estado do CRM:', data.doctor.crm_state);
      createTestsResultTable(data.tests);
      
      searchExamInfoDiv.appendChild(foundExamList);
      alerts.classList = 'alert success';
      alerts.innerHTML = 'Exame encontrado com sucesso!'
      console.log(data);
    })
});

// Botão para retornar ao modo de visualização da lista de resultados

const backToListButton = document.getElementById('back-to-list-button');

backToListButton.addEventListener('click', (event) => {
  event.preventDefault();
  listExamsSection.classList.toggle('hidden');
  searchExamResultsSection.classList.toggle('hidden');
  alerts.innerHTML = '';
  alerts.classList = '';
  searchExamResustsTableDiv.innerHTML = '';
  searchExamInfoDiv.innerHTML = '';
  resultToken.value = '';
});

// Formulário para realizar a importação de dados

const importDataForm = document.getElementById('import-data-form');

importDataForm.addEventListener('submit', (event) => {
  event.preventDefault();

  const fileInput = document.getElementById('import-data-file');
  const file = fileInput.files[0];

  const reader = new FileReader();
  reader.onload = function(event) {
    const arrayBuffer = event.target.result;
    const blob = new Blob([arrayBuffer]);
    const requestUrl = '/import';
    const requestOptions = {
      method: 'POST',
      body: blob,
    };

    fetch(requestUrl, requestOptions);
  }

  reader.readAsArrayBuffer(file);
  alerts.innerHTML = 'Importação de dados solicitada com sucesso! Em breve seus dados estarão disponíveis';
  alerts.classList = 'alert success';
  });