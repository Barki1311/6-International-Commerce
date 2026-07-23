dotnet
{
    assembly("System.Net.Http")
    {
        Version = '4.0.0.0';
        Culture = 'neutral';
        PublicKeyToken = 'b03f5f7f11d50a3a';
        /*
        type("System.Net.Http.HttpClient";"HttpClient"){}
        type("System.Net.Http.HttpContent";"HttpContent"){}
        type("System.Net.Http.HttpRequestMessage";"HttpRequestMessage"){}
        type("System.Net.Http.HttpResponseMessage";"HttpResponseMessage"){}
        type("System.Net.Http.StringContent";"StringContent"){}
        type("System.Net.Http.HttpMethod";"HttpMethod"){}
        type("System.Net.Http.Headers.HttpRequestHeaders";"HttpRequestHeaders"){}
        */
    }

    assembly("System")
    {
        Version = '4.0.0.0';
        Culture = 'neutral';
        PublicKeyToken = 'b77a5c561934e089';

        // type("System.Uri"; "Uri") { }
    }
    /*
    assembly("mscorlib")
    {
        Version = '2.0.0.0';
        Culture = 'neutral';
        PublicKeyToken = 'b77a5c561934e089';

        // type("System.Text.Encoding"; "Encoding") { }
    }
    */

    assembly("System.Xml")
    {
        Version = '4.0.0.0';
        Culture = 'neutral';
        PublicKeyToken = 'b77a5c561934e089';
        /*
        type("System.Xml.XmlDocument"; "XmlDocument") { }
        type("System.Xml.XmlNode"; "XmlNode") { }
        type("System.Xml.XmlNodeList"; "XmlNodeList") { }
        type("System.Xml.XmlNamedNodeMap"; "XmlNamedNodeMap") { }
        type("System.Xml.XmlAttribute"; "XmlAttribute") { }
        type("System.Xml.XmlElement"; "XmlElement") { }
        type("System.Xml.XmlText"; "XmlText") { }
        type("System.Xml.XmlNodeChangedEventArgs"; "XmlNodeChangedEventArgs") { }
        */
    }
    /*
        assembly("KosmosTek.QRCode")
        {
            Version = '2.4.0.0';
            Culture = 'neutral';
            PublicKeyToken = '840004e83a130083';

            type("KosmosTek.QRCode.Code"; "Code") { }
        }
    
    assembly("System.Drawing")
    {
        Version = '2.0.0.0';
        Culture = 'neutral';
        PublicKeyToken = 'b03f5f7f11d50a3a';

        type("System.Drawing.Image"; "Image") { }
        type("System.Drawing.Imaging.ImageFormat"; "ImageFormat") { }
    }
*/
}
