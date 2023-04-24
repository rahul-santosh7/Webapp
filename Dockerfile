#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["webapp1/webapp1.csproj", "webapp1/"]
RUN dotnet restore "webapp2/webapp2.csproj"
COPY . .
WORKDIR "/src/webapp1"
RUN dotnet build "webapp1.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "webapp1.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "webapp1.dll"]
