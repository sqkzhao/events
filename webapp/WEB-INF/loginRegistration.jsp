<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html>
<html>
	<head>
		<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
		<title>Welcome</title>
	</head>
	<body>
		<div class="container">
			<h1>Welcome</h1>
			<div class="row">
				<div class="col border mr-3 p-5">
					<h5>Registration</h5>
					<form:form action="/registration" method="post" modelAttribute="user">
						<P><form:errors path="user.*"/></P>
						<p>
							<form:label path="firstName">First Name:</form:label>
							<form:input path="firstName"/>
						</p>
						<P><form:errors path="firstName" class="text-danger"/></P>
						<p>
							<form:label path="lastName">Last Name:</form:label>
							<form:input path="lastName"/>
						</p>
						<P><form:errors path="lastName" class="text-danger"/></P>
						<p>
							<form:label path="email">Email:</form:label>
							<form:input path="email" type="email"/>
						</p>
						<P><form:errors path="email" class="text-danger"/></P>
						<p>
							<form:label path="location">Location:</form:label>
							<form:input path="location"/>
							<form:select path="state">
								<form:option value=""></form:option>
								<form:option value="ca">CA</form:option>
								<form:option value="ny">NY</form:option>
								<form:option value="ut">UT</form:option>
							</form:select>
						</p>
						<P><form:errors path="location" class="text-danger"/></P>
						<P><form:errors path="state" class="text-danger"/></P>
						<p>
							<form:label path="password">Password:</form:label>
							<form:password path="password"/>
						</p>
						<P><form:errors path="password" class="text-danger"/></P>
						<p>
							<form:label path="passwordConfirmation">Password Confirmation:</form:label>
							<form:password path="passwordConfirmation"/>
						</p>
						<P><form:errors path="passwordConfirmation" class="text-danger"/></P>
						<input type="submit" value="Register" class="btn btn-dark"/>
					</form:form>
				</div>
				<div class="col border ml-3 p-5">
					<h5>Login</h5>
					<form action="/login" method="post">
						<p>
							<label for="email">Email:</label>
							<input type="text" name="email"/>
						</p>
						<p>
							<label for="password">Password:</label>
							<input type="password" name="password"/>
						</p>
						<p class="text-danger"><c:out value="${error}" /></p>
						<input type="submit" value="Login" class="btn btn-dark"/>
					</form>
				</div>
			</div>
		</div>
	</body>
</html>