# Use the ASP.NET runtime as the base image
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80

# Use the .NET SDK as the build image
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["GitHubActionsDemo.csproj", "./"]
RUN dotnet restore "./GitHubActionsDemo.csproj"
COPY . .
RUN dotnet build "./GitHubActionsDemo.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "./GitHubActionsDemo.csproj" -c Release -o /app/publish

# Use the base image to build the final image
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "GitHubActionsDemo.dll"]
