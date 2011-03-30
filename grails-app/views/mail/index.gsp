<html>
  <body>
    <div>Send publication e-mail</div>
    <div>${flash.message}</div>
    <table>
      <tr>
        <td>Publication Name</td>
        <td>File Name</td>
        <td>Action</td>
      </tr>
      <g:each in="${publications}" var="pub">
      <tr>
        <td>${pub.pubLongName}</td>
        <td>${pub.fileName}</td>
        <td><a href="${createLink(controller:'mail', action:'mail', id:pub.id)}">Send Mail</a></td>
      </tr>
      </g:each>
    </table>

  </body>
</html>