import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final HttpLink httpLink = HttpLink(
      uri: 'https://countries-274616.ew.r.appspot.com/',
    );
    final ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
      GraphQLClient(cache: InMemoryCache(), link: httpLink),
    );
    return GraphQLProvider(
      client: client,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          title: Text("GraphQL"),
          centerTitle: true,
        ),
        body: Container(
          child: Query(
            options: QueryOptions(
              documentNode: gql(r"""
               query{
                Country {
                  name
                  population
                  capital
                  flag{
                    svgFile
                   }
                }
              }
               """),
            ),
            builder: (QueryResult result, {fetchMore, refetch}) {
              if (result.hasException) {
                return Text(result.hasException.toString());
              }
              if (result.loading) {
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.deepPurple,
                  ),
                );
              }
              List countries = result.data['Country'];
              return ListView.builder(
                itemCount: countries.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      color: Colors.white10,
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12.0, left: 12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Country Name : ${countries[index]['name']}",
                              style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.white),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Population : ${countries[index]['population'].toString()}",
                              style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  color: Colors.white54),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Capital : ${countries[index]['capital']}",
                              style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  color: Colors.white54),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            RaisedButton(
                              color: Colors.white,
                              onPressed: () {},
                              child: Text(
                                "More Info",
                                style:
                                    GoogleFonts.montserrat(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
