<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
	<head>
		<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
		<title><c:out value="${event.name}"/></title>
	</head>
	<body>
		<div class="container">
			<h1><c:out value="${event.name}"/></h1>
			<div class="row">
				<div class="col">
					<p>Host: <c:out value="${event.user.firstName}"/></p>
					<p>Date: <fmt:formatDate dateStyle = "long" value = "${event.date}" /></p>
					<p>Location: <c:out value="${event.location}"/></p>
					<p>People who are attending this event: <c:out value="${count}"/></p>
					<table class="table">
						<thead>
							<tr>
								<th>Name</th>
								<th>Location</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach items="${event.members}" var="member">
								<tr>
									<td>
										<c:out value="${member.firstName}"/>
										<c:out value="${member.lastName}"/>
									</td>
									<td><c:out value="${member.location}"/></td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>
				<div class="col">
					<h3>Message Wall</h3>
				</div>
			</div>
		</div>
	</body>
</html>