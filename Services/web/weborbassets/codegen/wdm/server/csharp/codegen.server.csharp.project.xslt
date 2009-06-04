<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" 
  xmlns:codegen="urn:cogegen-xslt-lib:xslt"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="codegen.server.csharp.domain.xslt"/>
  <xsl:import href="data/codegen.server.csharp.data.xslt"/>


  <xsl:template name="codegen.server.csharp.project">
    <file name="{codegen:getProjectName()}.csproj" overwrite="false" type="xml">
      <Project DefaultTargets="Build" xmlns="http://schemas.microsoft.com/developer/msbuild/2003">
        <PropertyGroup>
          <Configuration Condition=" '$(Configuration)' == '' ">Debug</Configuration>
          <Platform Condition=" '$(Platform)' == '' ">AnyCPU</Platform>
          <ProductVersion>8.0.50727</ProductVersion>
          <SchemaVersion>2.0</SchemaVersion>
          <ProjectGuid>
            <xsl:value-of select="codegen:getGuid()"/>
          </ProjectGuid>
          <OutputType>Library</OutputType>
          <AppDesignerFolder>Properties</AppDesignerFolder>
          <RootNamespace>
            <xsl:value-of select="codegen:getServerNamespace()"/>
          </RootNamespace>
          <AssemblyName><xsl:value-of select="codegen:getProjectName()"/></AssemblyName>
          <StartupObject />
        </PropertyGroup>
        <PropertyGroup Condition=" '$(Configuration)|$(Platform)' == 'Debug|AnyCPU' ">
          <DebugSymbols>true</DebugSymbols>
          <DebugType>full</DebugType>
          <Optimize>false</Optimize>
          <OutputPath>Bin\Debug</OutputPath>
          <DefineConstants>TRACE;DEBUG;WIN32</DefineConstants>
          <ErrorReport>prompt</ErrorReport>
          <WarningLevel>4</WarningLevel>
        </PropertyGroup>
        <PropertyGroup Condition=" '$(Configuration)|$(Platform)' == 'Release|AnyCPU' ">
          <DebugType>pdbonly</DebugType>
          <Optimize>true</Optimize>
          <OutputPath>Bin\Release</OutputPath>
          <DefineConstants>TRACE;WIN32</DefineConstants>
          <ErrorReport>prompt</ErrorReport>
          <WarningLevel>4</WarningLevel>
        </PropertyGroup>
        <ItemGroup>
          <Reference Include="System" />
          <Reference Include="System.Data" />
          <Reference Include="System.Xml" />
          <Reference Include="System.configuration" />
	  <Reference Include="weborb">
	    <SpecificVersion>False</SpecificVersion>
	    <HintPath><xsl:value-of select="codegen:getWebORBDllPath()"/></HintPath>
	  </Reference>
        <xsl:if test="codegen:IsDBServerUsed('mysql')">
          <Reference Include="MySql.Data">
            <SpecificVersion>False</SpecificVersion>
            <HintPath>
              <xsl:value-of select="codegen:getMySQLDllPath()"/>
            </HintPath>
          </Reference>
        </xsl:if>
        </ItemGroup>
        <ItemGroup>
          <None Include="App.config" />
        </ItemGroup>
        <ItemGroup>
          <Compile Include="**\*.cs" />
        </ItemGroup>
        <Import Project="$(MSBuildBinPath)\Microsoft.CSharp.targets" />
      </Project>
    </file>
  </xsl:template>
</xsl:stylesheet>