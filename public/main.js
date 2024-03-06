const tests_url = 'http://localhost:3000/tests'

fetch(tests_url)
  .then((response) => response.json())
  .then((data) => {
    const table = document.getElementById('tbody')
    const pagination = document.getElementById('pagination');
    const itemsPerPage = 100;
    let currentPage = 0;

    function displayData(data, page) {
      table.innerHTML = '';
      const startIndex = page * itemsPerPage;
      const endIndex = startIndex + itemsPerPage;
      const pageData = data.slice(startIndex, endIndex);

      pageData.forEach(test => {
        const tr = document.createElement('tr');
        Object.values(test).forEach(value => {
          const td = document.createElement('td');
          td.textContent = `${value}`;
          td.classList.add('table-cell');
          tr.appendChild(td);
        })
        table.appendChild(tr);
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
        });
        pagination.appendChild(button);
      }
    };

    function setupTableHeaders(data) {
      const table_headers = new DocumentFragment();

      Object.keys(data[0]).forEach(key => {
        const th = document.createElement('th');
        th.textContent = `${key}`;
        th.classList.add('table-header');
        table_headers.appendChild(th);
      });

      document.querySelector('#table-headers').appendChild(table_headers);
    };

    console.log(data);
    setupTableHeaders(data);
    displayData(data, currentPage);
    setupPagination(data);
  });
