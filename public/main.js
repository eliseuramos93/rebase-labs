const table_data = new DocumentFragment(); // o que é DocumentFragment?
const table_headers = new DocumentFragment();
const tests_url = 'http://localhost:3000/tests'

fetch(tests_url).
  then((response) => response.json()). //essa linha converte para JSON? Ela faz um JSON.parse?
  then((data) => {
    Object.keys(data[0]).forEach(key => {
      const th = document.createElement('th');
      th.textContent = `${key}`;
      th.classList = 'table-header';
      table_headers.appendChild(th);
    });

    data.forEach(function(test) {
      const tr = document.createElement('tr');
      Object.values(test).forEach(value => {
        const td = document.createElement('td');
        td.textContent = `${value}`;
        td.classList = 'table-cell'
        tr.appendChild(td);
      });
      table_data.appendChild(tr);
})
  }).
  then(() => {
    document.querySelector('#table-headers').appendChild(table_headers)
    document.querySelector('tbody').appendChild(table_data)
  }).catch(function(error) {
    console.log(error);
  })
