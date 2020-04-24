<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html>
<html>
	<head>
		<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
		<title><c:out value="${event.name}"/></title>
	</head>
	<body>
		<div class="container">
			<h1><c:out value="${event.name}"/></h1>
			<h5>Edit Event</h5>
			<form:form action="/events/${event.id}/edit" method="post" modelAttribute="editedEvent">
				<p>
					<form:label path="name">Name</form:label>
					<form:input path="name" value="${event.name}" />
				</p>
				<p><form:errors path="name" class="text-danger" /></p>
				<p>
					<form:label path="date">Date</form:label>
					<form:input path="date" type="date" value="${date}"/>
				</p>
				<p><form:errors path="date" class="text-danger" /></p>
				<p>
					<form:label path="location">Location</form:label>
					<form:input path="location" value="${event.location}" />
					<form:select path="state">
						<form:option value=""></form:option>
						<form:option value="ca">CA</form:option>
						<form:option value="ny">NY</form:option>
						<form:option value="ut">UT</form:option>
					</form:select>
				</p>
				<p><form:errors path="location" class="text-danger" /></p>
				<p><form:errors path="state" class="text-danger" /></p>
				<form:input path="user" type="hidden" value="${currentUser.id}" />
				<input type="submit" value="Edit" class="btn btn-dark" />
			</form:form>
		</div>
	</body>
</html>