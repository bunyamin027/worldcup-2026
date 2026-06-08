const fs = require('fs');
const content = fs.readFileSync('cloudflare/worker.js', 'utf8');

// Use regex or eval to extract the data
const fixturesMatch = content.match(/const MOCK_FIXTURES = (\{[\s\S]*?\});\s*const MOCK_STANDINGS/);
const standingsMatch = content.match(/const MOCK_STANDINGS = (\{[\s\S]*?\});\s*export default/);

if (fixturesMatch && standingsMatch) {
    const fixturesStr = fixturesMatch[1];
    const standingsStr = standingsMatch[1];
    
    // We can evaluate them safely since it's just JS objects
    const fixtures = eval('(' + fixturesStr + ')');
    const standings = eval('(' + standingsStr + ')');
    
    // Format for our dart file
    let dartContent = "class MockData {\n";
    dartContent += "  static const List<dynamic> fixtures = " + JSON.stringify(fixtures.matches, null, 2) + ";\n\n";
    dartContent += "  static const List<dynamic> standings = " + JSON.stringify(standings.standings, null, 2) + ";\n";
    dartContent += "}\n";
    
    fs.writeFileSync('lib/data/mock_data.dart', dartContent);
    console.log("Successfully extracted MOCK_FIXTURES and MOCK_STANDINGS to mock_data.dart");
} else {
    console.log("Failed to extract data");
}
