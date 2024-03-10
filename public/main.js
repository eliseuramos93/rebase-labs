fetch(tests_url)
  .then((response) => response.json())
  .then((data) => {
    const table = document.getElementById('tbody')
    const pagination = document.getElementById('pagination');
    const itemsPerPage = 100;
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
              console.log(doctorValue)
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
    console.log(data[0])
  });
